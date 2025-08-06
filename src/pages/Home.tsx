import { ArrowRight, Code, Smartphone, TrendingUp, Palette, Brain, Search } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Link } from "react-router-dom"

const services = [
  { icon: Smartphone, title: "Mobile Development", desc: "Native & cross-platform apps" },
  { icon: Code, title: "Web Development", desc: "Modern, scalable web solutions" },
  { icon: TrendingUp, title: "Digital Marketing", desc: "Social media & SEO optimization" },
  { icon: Palette, title: "Branding", desc: "Creative brand identity design" },
  { icon: Brain, title: "AI Solutions", desc: "Cutting-edge artificial intelligence" },
  { icon: Search, title: "SEO", desc: "Search engine optimization" }
]

export default function Home() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-hero py-24 lg:py-32">
        <div className="container mx-auto px-4 text-center">
          <div className="animate-fade-in">
            <h1 className="text-4xl md:text-6xl lg:text-7xl font-bold mb-6">
              <span className="bg-gradient-primary bg-clip-text text-transparent animate-gradient-shift bg-[length:200%_200%]">
                Transform Your
              </span>
              <br />
              <span className="text-foreground">Digital Presence</span>
            </h1>
            <p className="text-xl md:text-2xl text-muted-foreground mb-8 max-w-3xl mx-auto">
              We craft exceptional mobile apps, stunning websites, and powerful AI solutions 
              that drive innovation and accelerate your business growth.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
              <Button size="lg" className="bg-gradient-primary hover:opacity-90 transition-opacity" asChild>
                <Link to="/contact">
                  Get Started Today
                  <ArrowRight className="ml-2 h-5 w-5" />
                </Link>
              </Button>
              <Button size="lg" variant="outline" asChild>
                <Link to="/portfolio">View Our Work</Link>
              </Button>
            </div>
          </div>
          
          {/* Floating Elements */}
          <div className="absolute top-10 left-10 w-20 h-20 bg-brand-coral/20 rounded-full animate-bounce-gentle hidden lg:block" />
          <div className="absolute top-32 right-20 w-16 h-16 bg-brand-blue/20 rounded-full animate-bounce-gentle delay-500 hidden lg:block" />
          <div className="absolute bottom-20 left-1/4 w-12 h-12 bg-brand-purple/20 rounded-full animate-bounce-gentle delay-1000 hidden lg:block" />
        </div>
      </section>

      {/* Services Preview */}
      <section className="py-20 bg-background">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">Our Expertise</h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              From concept to deployment, we offer comprehensive technology solutions
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {services.map((service, index) => (
              <Card key={service.title} className="group hover:shadow-lg transition-all duration-300 hover:-translate-y-1">
                <CardContent className="p-6">
                  <div className="mb-4">
                    <service.icon className="h-12 w-12 text-primary group-hover:text-brand-coral transition-colors" />
                  </div>
                  <h3 className="text-xl font-semibold mb-2">{service.title}</h3>
                  <p className="text-muted-foreground">{service.desc}</p>
                </CardContent>
              </Card>
            ))}
          </div>

          <div className="text-center mt-12">
            <Button variant="outline" size="lg" asChild>
              <Link to="/services">
                Explore All Services
                <ArrowRight className="ml-2 h-5 w-5" />
              </Link>
            </Button>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-secondary">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            Ready to Start Your Project?
          </h2>
          <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            Let's discuss how we can help bring your vision to life with cutting-edge technology solutions.
          </p>
          <Button size="lg" variant="secondary" asChild>
            <Link to="/contact">
              Get a Free Consultation
              <ArrowRight className="ml-2 h-5 w-5" />
            </Link>
          </Button>
        </div>
      </section>
    </div>
  )
}