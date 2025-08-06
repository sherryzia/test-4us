import { useParams, Link } from "react-router-dom"
import { Calendar, User, Clock, ArrowLeft, Share2 } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"

// Sample blog post content
const blogPost = {
  id: 1,
  title: "The Future of Mobile App Development: Trends to Watch in 2024",
  content: `
    <h2>Introduction</h2>
    <p>Mobile app development continues to evolve at a rapid pace, driven by technological advances and changing user expectations. As we move through 2024, several key trends are reshaping how we approach mobile application development.</p>
    
    <h2>AI Integration</h2>
    <p>Artificial Intelligence is no longer a luxury feature but a necessity. From personalized user experiences to intelligent automation, AI is becoming deeply integrated into mobile applications. Machine learning algorithms are enabling apps to learn from user behavior and provide more relevant content and suggestions.</p>
    
    <h2>Cross-Platform Development</h2>
    <p>With the rise of frameworks like Flutter and React Native, cross-platform development has become more sophisticated. These frameworks now offer near-native performance while maintaining code reusability across platforms, making them increasingly attractive for businesses looking to optimize development costs.</p>
    
    <h2>5G Technology Impact</h2>
    <p>The widespread adoption of 5G networks is opening new possibilities for mobile applications. Enhanced connectivity enables real-time AR/VR experiences, improved video streaming, and more responsive cloud-based applications. Developers are now exploring new use cases that were previously limited by network constraints.</p>
    
    <h2>Privacy and Security</h2>
    <p>With increasing concerns about data privacy, mobile app developers are prioritizing security features. Implementing robust encryption, secure authentication methods, and transparent data handling practices has become essential for user trust and regulatory compliance.</p>
    
    <h2>Conclusion</h2>
    <p>The mobile app development landscape is more exciting than ever. By staying informed about these trends and incorporating them into our development strategies, we can create applications that not only meet current user needs but also anticipate future requirements.</p>
  `,
  author: "Michael Chen",
  date: "2024-01-15",
  readTime: "5 min read",
  category: "Mobile Development",
  image: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800",
}

export default function BlogPost() {
  const { id } = useParams()

  return (
    <div className="min-h-screen">
      {/* Header */}
      <section className="py-8 bg-muted/50">
        <div className="container mx-auto px-4">
          <Button variant="ghost" asChild className="mb-4">
            <Link to="/blog">
              <ArrowLeft className="mr-2 h-4 w-4" />
              Back to Blog
            </Link>
          </Button>
        </div>
      </section>

      {/* Article */}
      <article className="py-12">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto">
            {/* Article Header */}
            <header className="mb-8">
              <div className="mb-4">
                <Badge variant="secondary">{blogPost.category}</Badge>
              </div>
              
              <h1 className="text-3xl md:text-4xl font-bold mb-6 leading-tight">
                {blogPost.title}
              </h1>
              
              <div className="flex flex-wrap items-center gap-6 text-muted-foreground mb-6">
                <div className="flex items-center space-x-2">
                  <User className="h-4 w-4" />
                  <span>{blogPost.author}</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Calendar className="h-4 w-4" />
                  <span>{new Date(blogPost.date).toLocaleDateString()}</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Clock className="h-4 w-4" />
                  <span>{blogPost.readTime}</span>
                </div>
              </div>

              <div className="flex items-center gap-4 mb-8">
                <Button variant="outline" size="sm">
                  <Share2 className="mr-2 h-4 w-4" />
                  Share Article
                </Button>
              </div>
            </header>

            {/* Featured Image */}
            <div className="mb-8">
              <img
                src={blogPost.image}
                alt={blogPost.title}
                className="w-full h-64 md:h-96 object-cover rounded-lg"
              />
            </div>

            {/* Article Content */}
            <div 
              className="prose prose-lg max-w-none"
              dangerouslySetInnerHTML={{ __html: blogPost.content }}
            />

            {/* Article Footer */}
            <footer className="mt-12 pt-8 border-t">
              <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <div>
                  <p className="text-sm text-muted-foreground">Written by</p>
                  <p className="font-semibold">{blogPost.author}</p>
                </div>
                <Button variant="outline" asChild>
                  <Link to="/blog">
                    Read More Articles
                  </Link>
                </Button>
              </div>
            </footer>
          </div>
        </div>
      </article>

      {/* Related Articles */}
      <section className="py-16 bg-muted/50">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto">
            <h2 className="text-2xl font-bold mb-8">Related Articles</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <Link to="/blog/2" className="group">
                <div className="bg-background rounded-lg p-6 hover:shadow-lg transition-shadow">
                  <Badge variant="outline" className="mb-3">Digital Marketing</Badge>
                  <h3 className="font-semibold mb-2 group-hover:text-primary transition-colors">
                    Maximizing ROI with Strategic Social Media Marketing
                  </h3>
                  <p className="text-sm text-muted-foreground">
                    Learn how to create social media campaigns that drive real business results...
                  </p>
                </div>
              </Link>
              
              <Link to="/blog/3" className="group">
                <div className="bg-background rounded-lg p-6 hover:shadow-lg transition-shadow">
                  <Badge variant="outline" className="mb-3">AI Solutions</Badge>
                  <h3 className="font-semibold mb-2 group-hover:text-primary transition-colors">
                    AI Integration in Web Applications: A Practical Guide
                  </h3>
                  <p className="text-sm text-muted-foreground">
                    Discover how to seamlessly integrate AI capabilities into your web applications...
                  </p>
                </div>
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}