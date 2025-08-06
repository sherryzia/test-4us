import { Calendar, User, ArrowRight, Clock } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Link } from "react-router-dom"

const blogPosts = [
  {
    id: 1,
    title: "The Future of Mobile App Development: Trends to Watch in 2024",
    summary: "Explore the latest trends shaping mobile app development, from AI integration to cross-platform frameworks.",
    content: "Mobile app development continues to evolve at a rapid pace...",
    author: "Michael Chen",
    date: "2024-01-15",
    readTime: "5 min read",
    category: "Mobile Development",
    image: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=600",
    featured: true
  },
  {
    id: 2,
    title: "Maximizing ROI with Strategic Social Media Marketing",
    summary: "Learn how to create social media campaigns that drive real business results and measure success effectively.",
    content: "Social media marketing has become an essential component...",
    author: "Lisa Thompson",
    date: "2024-01-12",
    readTime: "7 min read",
    category: "Digital Marketing",
    image: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=600",
    featured: false
  },
  {
    id: 3,
    title: "AI Integration in Web Applications: A Practical Guide",
    summary: "Discover how to seamlessly integrate AI capabilities into your web applications for enhanced user experiences.",
    content: "Artificial intelligence is no longer a futuristic concept...",
    author: "James Wilson",
    date: "2024-01-10",
    readTime: "8 min read",
    category: "AI Solutions",
    image: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=600",
    featured: true
  },
  {
    id: 4,
    title: "Building Brand Identity in the Digital Age",
    summary: "Understand the key elements of creating a compelling brand identity that resonates with modern audiences.",
    content: "In today's digital landscape, brand identity extends far beyond...",
    author: "Emily Rodriguez",
    date: "2024-01-08",
    readTime: "6 min read",
    category: "Branding",
    image: "https://images.unsplash.com/photo-1634942537034-2531766767d1?w=600",
    featured: false
  },
  {
    id: 5,
    title: "SEO Best Practices for 2024: What's Changed and What Hasn't",
    summary: "Stay ahead of the curve with the latest SEO strategies and algorithm updates that matter for your business.",
    content: "Search engine optimization continues to be a critical factor...",
    author: "David Park",
    date: "2024-01-05",
    readTime: "9 min read",
    category: "SEO",
    image: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600",
    featured: false
  },
  {
    id: 6,
    title: "The Rise of Progressive Web Apps: Why Your Business Needs One",
    summary: "Explore how Progressive Web Apps are revolutionizing user experiences and driving business growth.",
    content: "Progressive Web Apps (PWAs) represent a significant shift...",
    author: "Sarah Johnson",
    date: "2024-01-03",
    readTime: "7 min read",
    category: "Web Development",
    image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600",
    featured: true
  }
]

const categories = ["All", "Mobile Development", "Web Development", "Digital Marketing", "Branding", "AI Solutions", "SEO"]

export default function Blog() {
  const featuredPosts = blogPosts.filter(post => post.featured)
  const recentPosts = blogPosts.filter(post => !post.featured)

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-hero">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl md:text-5xl font-bold mb-6">Our Blog</h1>
            <p className="text-xl text-muted-foreground">
              Insights, tips, and industry trends from our team of experts. 
              Stay updated with the latest in technology and digital innovation.
            </p>
          </div>
        </div>
      </section>

      {/* Featured Posts */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold mb-12 text-center">Featured Articles</h2>
          
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-16">
            {featuredPosts.slice(0, 2).map((post) => (
              <Card key={post.id} className="group overflow-hidden hover:shadow-xl transition-all duration-300">
                <div className="relative overflow-hidden">
                  <img
                    src={post.image}
                    alt={post.title}
                    className="w-full h-48 object-cover transition-transform duration-300 group-hover:scale-110"
                  />
                  <div className="absolute top-4 left-4">
                    <Badge className="bg-gradient-primary text-white">Featured</Badge>
                  </div>
                </div>
                
                <CardHeader>
                  <div className="flex items-center space-x-4 text-sm text-muted-foreground mb-2">
                    <div className="flex items-center space-x-1">
                      <User className="h-4 w-4" />
                      <span>{post.author}</span>
                    </div>
                    <div className="flex items-center space-x-1">
                      <Calendar className="h-4 w-4" />
                      <span>{new Date(post.date).toLocaleDateString()}</span>
                    </div>
                    <div className="flex items-center space-x-1">
                      <Clock className="h-4 w-4" />
                      <span>{post.readTime}</span>
                    </div>
                  </div>
                  
                  <Badge variant="secondary" className="w-fit mb-2">{post.category}</Badge>
                  <h3 className="text-xl font-semibold mb-2 group-hover:text-primary transition-colors">
                    {post.title}
                  </h3>
                  <p className="text-muted-foreground">{post.summary}</p>
                </CardHeader>
                
                <CardContent className="pt-0">
                  <Button variant="ghost" className="p-0 h-auto text-primary hover:text-primary/80" asChild>
                    <Link to={`/blog/${post.id}`}>
                      Read More
                      <ArrowRight className="ml-2 h-4 w-4" />
                    </Link>
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Recent Posts */}
      <section className="py-20 bg-muted/50">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold mb-12 text-center">Recent Articles</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {recentPosts.map((post) => (
              <Card key={post.id} className="group hover:shadow-lg transition-all duration-300">
                <div className="relative overflow-hidden">
                  <img
                    src={post.image}
                    alt={post.title}
                    className="w-full h-40 object-cover transition-transform duration-300 group-hover:scale-105"
                  />
                </div>
                
                <CardContent className="p-6">
                  <div className="flex items-center space-x-4 text-sm text-muted-foreground mb-3">
                    <div className="flex items-center space-x-1">
                      <Calendar className="h-3 w-3" />
                      <span>{new Date(post.date).toLocaleDateString()}</span>
                    </div>
                    <div className="flex items-center space-x-1">
                      <Clock className="h-3 w-3" />
                      <span>{post.readTime}</span>
                    </div>
                  </div>
                  
                  <Badge variant="outline" className="mb-3">{post.category}</Badge>
                  <h3 className="text-lg font-semibold mb-2 group-hover:text-primary transition-colors line-clamp-2">
                    {post.title}
                  </h3>
                  <p className="text-muted-foreground text-sm mb-4 line-clamp-3">{post.summary}</p>
                  
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-muted-foreground">By {post.author}</span>
                    <Button variant="ghost" size="sm" asChild>
                      <Link to={`/blog/${post.id}`}>
                        Read More
                        <ArrowRight className="ml-1 h-3 w-3" />
                      </Link>
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Newsletter Signup */}
      <section className="py-20 bg-gradient-secondary">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            Stay Updated
          </h2>
          <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            Subscribe to our newsletter to receive the latest insights, tips, and industry updates 
            directly in your inbox.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center max-w-md mx-auto">
            <input
              type="email"
              placeholder="Enter your email"
              className="flex-1 px-4 py-3 rounded-lg border border-white/20 bg-white/10 text-white placeholder-white/70 focus:outline-none focus:ring-2 focus:ring-white/50"
            />
            <Button size="lg" variant="secondary">
              Subscribe
            </Button>
          </div>
        </div>
      </section>
    </div>
  )
}