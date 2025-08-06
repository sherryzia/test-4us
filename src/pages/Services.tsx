import { 
  Smartphone, 
  Code, 
  TrendingUp, 
  Users, 
  Search, 
  Palette, 
  Brain, 
  ArrowRight,
  CheckCircle
} from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Link } from "react-router-dom"

const services = [
  {
    icon: Smartphone,
    title: "Mobile App Development",
    description: "Native and cross-platform mobile applications that deliver exceptional user experiences",
    technologies: ["Kotlin", "Flutter", "React Native", "Swift UI"],
    features: [
      "iOS & Android Development",
      "Cross-platform Solutions",
      "UI/UX Design",
      "App Store Optimization",
      "Performance Optimization",
      "Integration & Testing"
    ]
  },
  {
    icon: Code,
    title: "Web Development",
    description: "Modern, scalable web applications built with cutting-edge technologies",
    technologies: ["React", "Next.js", "MERN Stack", ".NET"],
    features: [
      "Responsive Web Design",
      "Progressive Web Apps",
      "E-commerce Solutions",
      "API Development",
      "Database Design",
      "Cloud Deployment"
    ]
  },
  {
    icon: TrendingUp,
    title: "Social Media Marketing",
    description: "Strategic social media campaigns that boost engagement and drive conversions",
    technologies: ["Analytics", "Automation", "Content Strategy", "Paid Ads"],
    features: [
      "Campaign Strategy",
      "Content Creation",
      "Audience Targeting",
      "Performance Analytics",
      "Influencer Outreach",
      "ROI Optimization"
    ]
  },
  {
    icon: Users,
    title: "Social Media Management",
    description: "Comprehensive social media management to build and maintain your online presence",
    technologies: ["Content Planning", "Community Management", "Brand Monitoring"],
    features: [
      "Content Calendar",
      "Community Engagement",
      "Brand Monitoring",
      "Crisis Management",
      "Competitor Analysis",
      "Growth Strategies"
    ]
  },
  {
    icon: Search,
    title: "SEO",
    description: "Search engine optimization strategies that improve visibility and drive organic traffic",
    technologies: ["Keyword Research", "Technical SEO", "Content Optimization"],
    features: [
      "Keyword Research",
      "On-page Optimization",
      "Technical SEO",
      "Link Building",
      "Local SEO",
      "Performance Tracking"
    ]
  },
  {
    icon: Palette,
    title: "Branding",
    description: "Creative brand identity design that captures your unique voice and values",
    technologies: ["Design Systems", "Brand Guidelines", "Visual Identity"],
    features: [
      "Logo Design",
      "Brand Strategy",
      "Visual Identity",
      "Brand Guidelines",
      "Marketing Materials",
      "Brand Consultation"
    ]
  },
  {
    icon: Brain,
    title: "AI Solutions",
    description: "Cutting-edge artificial intelligence solutions that automate and optimize your business",
    technologies: ["Machine Learning", "Natural Language Processing", "Computer Vision"],
    features: [
      "Custom AI Models",
      "Chatbot Development",
      "Process Automation",
      "Data Analytics",
      "Predictive Modeling",
      "AI Integration"
    ]
  }
]

export default function Services() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-hero">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl md:text-5xl font-bold mb-6">Our Services</h1>
            <p className="text-xl text-muted-foreground">
              Comprehensive technology solutions designed to accelerate your digital transformation 
              and drive sustainable business growth.
            </p>
          </div>
        </div>
      </section>

      {/* Services Grid */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
            {services.map((service, index) => (
              <Card key={service.title} className="group hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
                <CardHeader>
                  <div className="flex items-center space-x-4 mb-4">
                    <div className="p-3 bg-gradient-primary rounded-lg text-white">
                      <service.icon className="h-8 w-8" />
                    </div>
                    <CardTitle className="text-2xl">{service.title}</CardTitle>
                  </div>
                  <p className="text-muted-foreground">{service.description}</p>
                </CardHeader>
                
                <CardContent className="space-y-6">
                  {/* Technologies */}
                  <div>
                    <h4 className="font-semibold mb-3">Technologies & Tools</h4>
                    <div className="flex flex-wrap gap-2">
                      {service.technologies.map((tech) => (
                        <span
                          key={tech}
                          className="px-3 py-1 bg-accent text-accent-foreground rounded-full text-sm"
                        >
                          {tech}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Features */}
                  <div>
                    <h4 className="font-semibold mb-3">What We Offer</h4>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                      {service.features.map((feature) => (
                        <div key={feature} className="flex items-center space-x-2">
                          <CheckCircle className="h-4 w-4 text-brand-coral flex-shrink-0" />
                          <span className="text-sm text-muted-foreground">{feature}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Process Section */}
      <section className="py-20 bg-muted/50">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">Our Process</h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              A proven methodology that ensures successful project delivery from concept to launch
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            {[
              { step: "01", title: "Discovery", desc: "Understanding your goals and requirements" },
              { step: "02", title: "Strategy", desc: "Crafting the perfect solution approach" },
              { step: "03", title: "Development", desc: "Building with precision and expertise" },
              { step: "04", title: "Launch", desc: "Deployment and ongoing support" }
            ].map((phase, index) => (
              <div key={phase.step} className="text-center">
                <div className="relative">
                  <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center text-white font-bold text-xl mx-auto mb-4">
                    {phase.step}
                  </div>
                  {index < 3 && (
                    <div className="hidden md:block absolute top-8 left-16 w-full h-0.5 bg-gradient-primary transform -translate-y-0.5" />
                  )}
                </div>
                <h3 className="text-xl font-semibold mb-2">{phase.title}</h3>
                <p className="text-muted-foreground">{phase.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-secondary">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            Ready to Get Started?
          </h2>
          <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            Let's discuss your project requirements and explore how our services can help 
            achieve your business objectives.
          </p>
          <Button size="lg" variant="secondary" asChild>
            <Link to="/contact">
              Start Your Project
              <ArrowRight className="ml-2 h-5 w-5" />
            </Link>
          </Button>
        </div>
      </section>
    </div>
  )
}