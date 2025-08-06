import { useState } from "react"
import { ExternalLink, Github, Filter } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

const projects = [
  {
    id: 1,
    title: "E-Commerce Mobile App",
    category: "Mobile Development",
    description: "A full-featured shopping app with real-time inventory and payment integration",
    image: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=600",
    technologies: ["React Native", "Node.js", "MongoDB", "Stripe"],
    liveUrl: "#",
    githubUrl: "#"
  },
  {
    id: 2,
    title: "SaaS Dashboard",
    category: "Web Development",
    description: "Modern analytics dashboard with real-time data visualization",
    image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600",
    technologies: ["React", "TypeScript", "D3.js", "PostgreSQL"],
    liveUrl: "#",
    githubUrl: "#"
  },
  {
    id: 3,
    title: "Brand Identity Redesign",
    category: "Branding",
    description: "Complete brand transformation for a tech startup",
    image: "https://images.unsplash.com/photo-1634942537034-2531766767d1?w=600",
    technologies: ["Figma", "Adobe Creative Suite", "Brand Strategy"],
    liveUrl: "#",
    githubUrl: "#"
  },
  {
    id: 4,
    title: "AI Chatbot Platform",
    category: "AI Solutions",
    description: "Intelligent customer service chatbot with natural language processing",
    image: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=600",
    technologies: ["Python", "TensorFlow", "OpenAI API", "React"],
    liveUrl: "#",
    githubUrl: "#"
  },
  {
    id: 5,
    title: "Social Media Campaign",
    category: "Digital Marketing",
    description: "Multi-platform marketing campaign that increased engagement by 300%",
    image: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=600",
    technologies: ["Facebook Ads", "Instagram", "Analytics", "Content Strategy"],
    liveUrl: "#",
    githubUrl: "#"
  },
  {
    id: 6,
    title: "Restaurant Management System",
    category: "Web Development",
    description: "Complete restaurant management solution with POS integration",
    image: "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600",
    technologies: ["Next.js", "Prisma", "Stripe", "Tailwind CSS"],
    liveUrl: "#",
    githubUrl: "#"
  }
]

const categories = ["All", "Mobile Development", "Web Development", "Branding", "AI Solutions", "Digital Marketing"]

export default function Portfolio() {
  const [selectedCategory, setSelectedCategory] = useState("All")

  const filteredProjects = selectedCategory === "All" 
    ? projects 
    : projects.filter(project => project.category === selectedCategory)

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-hero">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl md:text-5xl font-bold mb-6">Our Portfolio</h1>
            <p className="text-xl text-muted-foreground">
              Explore our recent projects and see how we've helped businesses achieve 
              their digital transformation goals.
            </p>
          </div>
        </div>
      </section>

      {/* Filter Tabs */}
      <section className="py-12 border-b">
        <div className="container mx-auto px-4">
          <div className="flex flex-wrap justify-center gap-2">
            {categories.map((category) => (
              <Button
                key={category}
                variant={selectedCategory === category ? "default" : "ghost"}
                onClick={() => setSelectedCategory(category)}
                className="mb-2"
              >
                <Filter className="h-4 w-4 mr-2" />
                {category}
              </Button>
            ))}
          </div>
        </div>
      </section>

      {/* Projects Grid */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {filteredProjects.map((project) => (
              <Card key={project.id} className="group overflow-hidden hover:shadow-xl transition-all duration-300">
                <div className="relative overflow-hidden">
                  <img
                    src={project.image}
                    alt={project.title}
                    className="w-full h-48 object-cover transition-transform duration-300 group-hover:scale-110"
                  />
                  <div className="absolute inset-0 bg-gradient-primary opacity-0 group-hover:opacity-90 transition-opacity duration-300 flex items-center justify-center space-x-4">
                    <Button size="sm" variant="secondary" asChild>
                      <a href={project.liveUrl} target="_blank" rel="noopener noreferrer">
                        <ExternalLink className="h-4 w-4" />
                      </a>
                    </Button>
                    <Button size="sm" variant="secondary" asChild>
                      <a href={project.githubUrl} target="_blank" rel="noopener noreferrer">
                        <Github className="h-4 w-4" />
                      </a>
                    </Button>
                  </div>
                </div>
                
                <CardContent className="p-6">
                  <div className="mb-2">
                    <Badge variant="secondary">{project.category}</Badge>
                  </div>
                  <h3 className="text-xl font-semibold mb-2">{project.title}</h3>
                  <p className="text-muted-foreground mb-4">{project.description}</p>
                  
                  <div className="flex flex-wrap gap-2">
                    {project.technologies.map((tech) => (
                      <span
                        key={tech}
                        className="px-2 py-1 bg-accent text-accent-foreground rounded text-xs"
                      >
                        {tech}
                      </span>
                    ))}
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-secondary">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            Have a Project in Mind?
          </h2>
          <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            Let's collaborate to create something amazing. We'd love to hear about your ideas 
            and discuss how we can bring them to life.
          </p>
          <Button size="lg" variant="secondary" asChild>
            <a href="/contact">
              Let's Work Together
            </a>
          </Button>
        </div>
      </section>
    </div>
  )
}