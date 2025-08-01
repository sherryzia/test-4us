# social/management/commands/seed_data.py
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.utils import timezone
from datetime import datetime, timedelta
import random
import string

# Import your models
from social.models import Post, Comment, Follow, PostLike, CommentLike, Chat, Message, Block

User = get_user_model()

class Command(BaseCommand):
    help = 'Seed the database with sample data for social media platform'

    def add_arguments(self, parser):
        parser.add_argument(
            '--users',
            type=int,
            default=50,
            help='Number of users to create',
        )
        parser.add_argument(
            '--posts',
            type=int,
            default=200,
            help='Number of posts to create',
        )
        parser.add_argument(
            '--comments',
            type=int,
            default=500,
            help='Number of comments to create',
        )

    def handle(self, *args, **options):
        self.stdout.write('🌱 Starting database seeding...')
        
        # Check if data already exists
        existing_users = User.objects.filter(is_superuser=False, is_staff=False).count()
        existing_posts = Post.objects.count()
        
        if existing_users > 0 or existing_posts > 0:
            self.stdout.write(f'Found {existing_users} existing users and {existing_posts} existing posts')
            clear_choice = input("Do you want to clear existing data? (y/N): ").lower()
            if clear_choice == 'y':
                self.clear_data()
            else:
                self.stdout.write('Keeping existing data and adding new data...')
        
        # Create users
        users = self.create_users(options['users'])
        self.stdout.write(f'✅ Created {len(users)} users')
        
        # Create posts
        posts = self.create_posts(users, options['posts'])
        self.stdout.write(f'✅ Created {len(posts)} posts')
        
        # Create comments
        comments = self.create_comments(posts, users, options['comments'])
        self.stdout.write(f'✅ Created {len(comments)} comments')
        
        # Create follows and likes
        self.create_follows(users)
        self.create_likes(posts, users)
        self.create_chats(users)
        
        self.stdout.write(
            self.style.SUCCESS('🎉 Successfully seeded the database!')
        )

    def clear_data(self):
        """Clear existing social media data"""
        from django.db import transaction
        
        try:
            with transaction.atomic():
                # Delete in correct order to avoid foreign key constraints
                self.stdout.write('Deleting messages...')
                Message.objects.all().delete()
                
                self.stdout.write('Deleting chats...')
                Chat.objects.all().delete()
                
                self.stdout.write('Deleting comment likes...')
                CommentLike.objects.all().delete()
                
                self.stdout.write('Deleting post likes...')
                PostLike.objects.all().delete()
                
                self.stdout.write('Deleting comments...')
                Comment.objects.all().delete()
                
                self.stdout.write('Deleting posts...')
                Post.objects.all().delete()
                
                self.stdout.write('Deleting blocks...')
                Block.objects.all().delete()
                
                self.stdout.write('Deleting follows...')
                Follow.objects.all().delete()
                
                # Delete users except superuser and staff
                self.stdout.write('Deleting non-admin users...')
                users_to_delete = User.objects.filter(is_superuser=False, is_staff=False)
                count = users_to_delete.count()
                users_to_delete.delete()
                
                self.stdout.write(f'🗑️ Cleared existing data ({count} users and all related data)')
                
        except Exception as e:
            self.stdout.write(f'Error clearing data: {e}')
            self.stdout.write('Continuing without clearing...')

    def create_users(self, count):
        """Create sample users"""
        first_names = [
            'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
            'William', 'Elizabeth', 'David', 'Barbara', 'Richard', 'Susan', 'Joseph', 'Jessica',
            'Thomas', 'Sarah', 'Charles', 'Karen', 'Christopher', 'Nancy', 'Daniel', 'Lisa',
            'Matthew', 'Betty', 'Anthony', 'Helen', 'Mark', 'Sandra', 'Donald', 'Donna',
            'Steven', 'Carol', 'Paul', 'Ruth', 'Andrew', 'Sharon', 'Joshua', 'Michelle',
            'Kenneth', 'Laura', 'Kevin', 'Kimberly', 'Brian', 'Deborah', 'George', 'Dorothy'
        ]
        
        last_names = [
            'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
            'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
            'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson',
            'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker'
        ]
        
        users = []
        
        for i in range(count):
            first_name = random.choice(first_names)
            last_name = random.choice(last_names)
            
            # Generate unique username with timestamp to avoid conflicts
            base_username = f"{first_name.lower()}{random.randint(100, 9999)}"
            username = base_username
            counter = 1
            
            # Ensure username is unique
            while User.objects.filter(username=username).exists():
                username = f"{base_username}{counter}"
                counter += 1
            
            try:
                user = User.objects.create_user(
                    username=username,
                    email=f"{username}@example.com",
                    password='password123',  # Simple password for testing
                    first_name=first_name,
                    last_name=last_name,
                    email_verified=True,  # Auto-verify for seed data
                )
                
                # Add optional bio
                if random.random() < 0.6:  # 60% chance of having bio
                    bios = [
                        "Love sharing my thoughts and experiences!",
                        "Tech enthusiast and coffee lover ☕",
                        "Just here to connect with amazing people",
                        "Sharing my journey one post at a time",
                        "Always learning something new 📚",
                        "Creative soul with a passion for life",
                        "Building connections and spreading positivity",
                    ]
                    user.bio = random.choice(bios)
                    user.save()
                
                users.append(user)
                
            except Exception as e:
                self.stdout.write(f'Error creating user {username}: {e}')
                continue
        
        return users

    def create_posts(self, users, count):
        """Create sample posts"""
        post_templates = [
            "Just finished an amazing {activity}! The experience was {adjective} and I learned so much about {topic}.",
            "Does anyone else think that {topic} is becoming more {adjective} these days? Would love to hear your thoughts!",
            "Pro tip: When working on {topic}, always remember to {action}. It makes such a {adjective} difference!",
            "Had the most {adjective} conversation about {topic} today. Sometimes the best insights come from {source}.",
            "Quick question for everyone: What's your favorite way to {action} when dealing with {topic}?",
            "Feeling {adjective} after completing my latest project on {topic}. The journey was {adjective2} but so rewarding!",
            "Anyone interested in {topic}? I've been exploring this area and found some {adjective} insights to share.",
            "The more I learn about {topic}, the more {adjective} it becomes. What's something that surprised you recently?",
        ]
        
        activities = ['project', 'book', 'course', 'workshop', 'presentation', 'meeting', 'conference']
        adjectives = ['amazing', 'incredible', 'fascinating', 'interesting', 'challenging', 'rewarding', 'inspiring']
        topics = ['technology', 'design', 'business', 'creativity', 'learning', 'communication', 'innovation']
        actions = ['practice regularly', 'stay organized', 'ask questions', 'collaborate', 'experiment', 'reflect']
        sources = ['unexpected places', 'casual conversations', 'online communities', 'books', 'personal experience']
        
        posts = []
        
        for i in range(count):
            author = random.choice(users)
            template = random.choice(post_templates)
            
            # Fill in template
            content = template.format(
                activity=random.choice(activities),
                adjective=random.choice(adjectives),
                adjective2=random.choice(adjectives),
                topic=random.choice(topics),
                action=random.choice(actions),
                source=random.choice(sources)
            )
            
            # Generate title
            title_templates = [
                "Thoughts on {topic}",
                "My experience with {topic}",
                "Quick tips for {topic}",
                "Why {topic} matters",
                "Learning about {topic}",
                "The future of {topic}",
            ]
            
            title = random.choice(title_templates).format(topic=random.choice(topics))
            
            # Random post type
            post_type = random.choices(
                ['text', 'image', 'link'], 
                weights=[60, 30, 10]  # 60% text, 30% image, 10% link
            )[0]
            
            post = Post.objects.create(
                author=author,
                title=title,
                content=content,
                post_type=post_type,
                created_at=self.random_date_past(days=365)
            )
            
            # Add type-specific content
            if post_type == 'image':
                # For seed data, we'll use placeholder image URLs
                post.image = f"posts/images/placeholder_{i}.jpg"  # This would be a real file in production
                post.save()
            elif post_type == 'link':
                post.link_url = f"https://example-{i}.com"
                post.save()
            
            posts.append(post)
        
        return posts

    def create_comments(self, posts, users, count):
        """Create sample comments"""
        comment_templates = [
            "Great post! I really enjoyed reading about this topic.",
            "Thanks for sharing your insights. This is really helpful!",
            "I completely agree with your perspective on this.",
            "This reminds me of a similar experience I had recently.",
            "Interesting point! I never thought about it that way.",
            "Do you have any recommendations for learning more about this?",
            "This is exactly what I needed to read today. Thank you!",
            "I've been exploring this topic too. Your post adds great value.",
            "Well written! Looking forward to more content like this.",
            "This gives me some new ideas to try out. Appreciate the share!",
        ]
        
        comments = []
        
        for i in range(count):
            post = random.choice(posts)
            author = random.choice(users)
            
            # Don't let users comment on their own posts too often
            if author == post.author and random.random() < 0.7:
                continue
            
            content = random.choice(comment_templates)
            
            # Create comment with date after post creation
            comment_date = self.random_date_between(
                start_date=post.created_at,
                end_date=timezone.now()
            )
            
            comment = Comment.objects.create(
                post=post,
                author=author,
                content=content,
                created_at=comment_date
            )
            
            comments.append(comment)
        
        return comments

    def create_follows(self, users):
        """Create follow relationships"""
        follows_created = 0
        
        for user in users:
            # Each user follows random number of other users
            follow_count = random.randint(5, 25)
            potential_follows = [u for u in users if u != user]
            follows = random.sample(potential_follows, min(follow_count, len(potential_follows)))
            
            for followed_user in follows:
                Follow.objects.get_or_create(
                    follower=user,
                    following=followed_user
                )
                follows_created += 1
        
        self.stdout.write(f'✅ Created {follows_created} follow relationships')

    def create_likes(self, posts, users):
        """Create like relationships"""
        likes_created = 0
        
        for post in posts:
            # Random number of likes per post
            like_count = random.randint(0, len(users) // 3)
            likers = random.sample(users, min(like_count, len(users)))
            
            for user in likers:
                PostLike.objects.get_or_create(
                    user=user,
                    post=post
                )
                likes_created += 1
            
            # Update the post's like count
            post.likes_count = like_count
            post.save()
        
        self.stdout.write(f'✅ Created {likes_created} likes')

    def create_chats(self, users):
        """Create some chat conversations"""
        chats_created = 0
        messages_created = 0
        
        # Create random chat pairs
        for i in range(min(20, len(users) // 3)):  # Create up to 20 chats
            user1, user2 = random.sample(users, 2)
            
            chat, created = Chat.objects.get_or_create(
                participant1=user1,
                participant2=user2
            )
            
            if created:
                chats_created += 1
                
                # Add some messages to the chat
                message_count = random.randint(3, 15)
                for j in range(message_count):
                    sender = random.choice([user1, user2])
                    
                    messages = [
                        "Hey! How are you doing?",
                        "Great post you shared earlier!",
                        "Thanks for following me!",
                        "Love your content, keep it up!",
                        "What are you working on these days?",
                        "Hope you're having a great day!",
                        "Your latest post was really insightful.",
                        "Thanks for the support!",
                        "Looking forward to your next post.",
                        "Have a wonderful week!",
                    ]
                    
                    Message.objects.create(
                        chat=chat,
                        sender=sender,
                        content=random.choice(messages),
                        is_read=random.choice([True, False]),
                        created_at=self.random_date_between(
                            start_date=chat.created_at,
                            end_date=timezone.now()
                        )
                    )
                    messages_created += 1
        
        self.stdout.write(f'✅ Created {chats_created} chats with {messages_created} messages')

    def random_date_past(self, days=365):
        """Generate random date in the past"""
        end_date = timezone.now()
        start_date = end_date - timedelta(days=days)
        
        time_between = end_date - start_date
        days_between = time_between.days
        random_days = random.randrange(days_between)
        
        return start_date + timedelta(days=random_days)

    def random_date_between(self, start_date, end_date):
        """Generate random date between two dates"""
        time_between = end_date - start_date
        days_between = time_between.days
        
        if days_between <= 0:
            return end_date
        
        random_days = random.randrange(days_between)
        return start_date + timedelta(days=random_days)