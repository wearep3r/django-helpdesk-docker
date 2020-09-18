from django.contrib.auth import get_user_model
from django.contrib.sites.models import Site
from django.core import mail
from django.urls import reverse
from django.test import TestCase
from django.test.client import Client
from helpdesk.models import CustomField, Queue, Ticket

try:  # python 3
    from urllib.parse import urlparse
except ImportError:  # python 2
    from urlparse import urlparse

from helpdesk.templatetags.ticket_to_link import num_to_link
from helpdesk.views.staff import _is_my_ticket


class TicketActionsTestCase(TestCase):
    fixtures = ['emailtemplate.json']

    def setUp(self):
        self.queue_public = Queue.objects.create(
            title='Queue 1',
            slug='q1',
            allow_public_submission=True,
            new_ticket_cc='new.public@example.com',
            updated_ticket_cc='update.public@example.com'
        )

        self.ticket_data = {
            'title': 'Test Ticket',
            'description': 'Some Test Ticket',
        }

        self.client = Client()

    def loginUser(self, is_staff=True):
        """Create a staff user and login"""
        User = get_user_model()
        self.user = User.objects.create(
            username='User_1',
            is_staff=is_staff,
        )
        self.user.set_password('pass')
        self.user.save()
        self.client.login(username='User_1', password='pass')

    def test_delete_ticket_staff(self):
        # make staff user
        self.loginUser()

        """Tests whether staff can delete tickets"""
        ticket_data = dict(queue=self.queue_public, **self.ticket_data)
        ticket = Ticket.objects.create(**ticket_data)
        ticket_id = ticket.id

        response = self.client.get(reverse('helpdesk:delete', kwargs={'ticket_id': ticket_id}), follow=True)
        self.assertContains(response, 'Are you sure you want to delete this ticket')

        response = self.client.post(reverse('helpdesk:delete', kwargs={'ticket_id': ticket_id}), follow=True)
        first_redirect = response.redirect_chain[0]
        first_redirect_url = first_redirect[0]

        # Ensure we landed on the "View" page.
        # Django 1.9 compatible way of testing this
        # https://docs.djangoproject.com/en/1.9/releases/1.9/#http-redirects-no-longer-forced-to-absolute-uris
        urlparts = urlparse(first_redirect_url)
        self.assertEqual(urlparts.path, reverse('helpdesk:home'))

        # test ticket deleted
        with self.assertRaises(Ticket.DoesNotExist):
            Ticket.objects.get(pk=ticket_id)

    def test_update_ticket_staff(self):
        """Tests whether staff can update ticket details"""

        # make staff user
        self.loginUser()

        # create second user
        User = get_user_model()
        self.user2 = User.objects.create(
            username='User_2',
            is_staff=True,
        )

        initial_data = {
            'title': 'Private ticket test',
            'queue': self.queue_public,
            'assigned_to': self.user,
            'status': Ticket.OPEN_STATUS,
        }

        # create ticket
        ticket = Ticket.objects.create(**initial_data)
        ticket_id = ticket.id

        # assign new owner
        post_data = {
            'owner': self.user2.id,
        }
        response = self.client.post(reverse('helpdesk:update', kwargs={'ticket_id': ticket_id}), post_data, follow=True)
        self.assertContains(response, 'Changed Owner from User_1 to User_2')

        # change status with users email assigned and submitter email assigned,
        # which triggers emails being sent
        ticket.assigned_to = self.user2
        ticket.submitter_email = 'submitter@test.com'
        ticket.save()
        self.user2.email = 'user2@test.com'
        self.user2.save()
        self.user.email = 'user1@test.com'
        self.user.save()
        post_data = {
            'new_status': Ticket.CLOSED_STATUS,
            'public': True
        }

        # do this also to a newly assigned user (different from logged in one)
        ticket.assigned_to = self.user
        response = self.client.post(reverse('helpdesk:update', kwargs={'ticket_id': ticket_id}), post_data, follow=True)
        self.assertContains(response, 'Changed Status from Open to Closed')
        post_data = {
            'new_status': Ticket.OPEN_STATUS,
            'owner': self.user2.id,
            'public': True
        }
        response = self.client.post(reverse('helpdesk:update', kwargs={'ticket_id': ticket_id}), post_data, follow=True)
        self.assertContains(response, 'Changed Status from Open to Closed')

    def test_is_my_ticket(self):
        """Tests whether non-staff but assigned user still counts as owner"""

        # make non-staff user
        self.loginUser(is_staff=False)

        # create second user
        User = get_user_model()
        self.user2 = User.objects.create(
            username='User_2',
            is_staff=False,
        )

        initial_data = {
            'title': 'Private ticket test',
            'queue': self.queue_public,
            'assigned_to': self.user,
            'status': Ticket.OPEN_STATUS,
        }

        # create ticket
        ticket = Ticket.objects.create(**initial_data)

        self.assertEqual(_is_my_ticket(self.user, ticket), True)
        self.assertEqual(_is_my_ticket(self.user2, ticket), False)

    def test_num_to_link(self):
        """Test that we are correctly expanding links to tickets from IDs"""

        # make staff user
        self.loginUser()

        initial_data = {
            'title': 'Some private ticket',
            'queue': self.queue_public,
            'assigned_to': self.user,
            'status': Ticket.OPEN_STATUS,
        }

        # create ticket
        ticket = Ticket.objects.create(**initial_data)
        ticket_id = ticket.id

        # generate the URL text
        result = num_to_link('this is ticket#%s' % ticket_id)
        self.assertEqual(result, "this is ticket <a href='/helpdesk/tickets/%s/' class='ticket_link_status ticket_link_status_Open'>#%s</a>" % (ticket_id, ticket_id))

        result2 = num_to_link('whoa another ticket is here #%s huh' % ticket_id)
        self.assertEqual(result2, "whoa another ticket is here  <a href='/helpdesk/tickets/%s/' class='ticket_link_status ticket_link_status_Open'>#%s</a> huh" % (ticket_id, ticket_id))

    def test_create_ticket_getform(self):
        self.loginUser()
        response = self.client.get(reverse('helpdesk:submit'), follow=True)
        self.assertEqual(response.status_code, 200)

        # TODO this needs to be checked further
