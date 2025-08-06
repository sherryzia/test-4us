import { Linkedin, Twitter, Github, Mail } from "lucide-react"
import { Card, CardContent } from "@/components/ui/card"
import { Button } from "@/components/ui/button"

const team = [
  {
    id: 1,
    name: "Sarah Johnson",
    role: "CEO & Founder",
    bio: "Visionary leader with 10+ years in tech strategy and business development. Passionate about driving innovation and building lasting client relationships.",
    image: "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400",
    social: {
      linkedin: "#",
      twitter: "#",
      email: "sarah@wizmark.com"
    }
  },
  {
    id: 2,
    name: "Michael Chen",
    role: "CTO",
    bio: "Full-stack architect with expertise in scalable web applications and mobile development. Leading our technical vision and innovation initiatives.",
    image: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400",
    social: {
      linkedin: "#",
      github: "#",
      email: "michael@wizmark.com"
    }
  },
  {
    id: 3,
    name: "Emily Rodriguez",
    role: "Head of Design",
    bio: "Creative director specializing in user experience and brand identity. Bringing 8 years of design expertise to create compelling digital experiences.",
    image: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400",
    social: {
      linkedin: "#",
      twitter: "#",
      email: "emily@wizmark.com"
    }
  },
  {
    id: 4,
    name: "David Park",
    role: "Lead Developer",
    bio: "Senior developer passionate about clean code and modern frameworks. Specializes in React, Node.js, and mobile app development.",
    image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400",
    social: {
      linkedin: "#",
      github: "#",
      email: "david@wizmark.com"
    }
  },
  {
    id: 5,
    name: "Lisa Thompson",
    role: "Marketing Director",
    bio: "Digital marketing expert with proven track record in social media strategy, SEO, and growth hacking. Helping brands tell their story.",
    image: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400",
    social: {
      linkedin: "#",
      twitter: "#",
      email: "lisa@wizmark.com"
    }
  },
  {
    id: 6,
    name: "James Wilson",
    role: "AI Specialist",
    bio: "Machine learning engineer with PhD in Computer Science. Leading our AI initiatives and developing cutting-edge intelligent solutions.",
    image: "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400",
    social: {
      linkedin: "#",
      github: "#",
      email: "james@wizmark.com"
    }
  }
]

export default function Team() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-hero">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl md:text-5xl font-bold mb-6">Meet Our Team</h1>
            <p className="text-xl text-muted-foreground">
              The talented individuals behind WizMark's success. Each member brings unique expertise 
              and passion to deliver exceptional results for our clients.
            </p>
          </div>
        </div>
      </section>

      {/* Team Grid */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {team.map((member) => (
              <Card key={member.id} className="group text-center hover:shadow-xl transition-all duration-300">
                <CardContent className="p-6">
                  <div className="relative mb-6">
                    <img
                      src={member.image}
                      alt={member.name}
                      className="w-32 h-32 rounded-full mx-auto object-cover border-4 border-accent group-hover:border-primary transition-colors"
                    />
                    <div className="absolute inset-0 rounded-full bg-gradient-primary opacity-0 group-hover:opacity-20 transition-opacity w-32 h-32 mx-auto" />
                  </div>
                  
                  <h3 className="text-xl font-semibold mb-1">{member.name}</h3>
                  <p className="text-primary font-medium mb-4">{member.role}</p>
                  <p className="text-muted-foreground mb-6 text-sm leading-relaxed">{member.bio}</p>
                  
                  <div className="flex justify-center space-x-3">
                    {member.social.linkedin && (
                      <Button size="sm" variant="ghost" asChild>
                        <a href={member.social.linkedin} target="_blank" rel="noopener noreferrer">
                          <Linkedin className="h-4 w-4" />
                        </a>
                      </Button>
                    )}
                    {member.social.twitter && (
                      <Button size="sm" variant="ghost" asChild>
                        <a href={member.social.twitter} target="_blank" rel="noopener noreferrer">
                          <Twitter className="h-4 w-4" />
                        </a>
                      </Button>
                    )}
                    {member.social.github && (
                      <Button size="sm" variant="ghost" asChild>
                        <a href={member.social.github} target="_blank" rel="noopener noreferrer">
                          <Github className="h-4 w-4" />
                        </a>
                      </Button>
                    )}
                    <Button size="sm" variant="ghost" asChild>
                      <a href={`mailto:${member.social.email}`}>
                        <Mail className="h-4 w-4" />
                      </a>
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Culture Section */}
      <section className="py-20 bg-muted/50">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h2 className="text-3xl md:text-4xl font-bold mb-6">Our Culture</h2>
            <p className="text-lg text-muted-foreground mb-12">
              At WizMark, we believe that great work comes from great people working together. 
              Our culture is built on collaboration, continuous learning, and the shared goal 
              of exceeding client expectations.
            </p>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-2xl text-white">💡</span>
                </div>
                <h3 className="text-xl font-semibold mb-2">Innovation First</h3>
                <p className="text-muted-foreground">
                  We encourage creative thinking and aren't afraid to explore new technologies and approaches.
                </p>
              </div>
              
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-secondary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-2xl text-white">🤝</span>
                </div>
                <h3 className="text-xl font-semibold mb-2">Collaboration</h3>
                <p className="text-muted-foreground">
                  Every voice matters. We work together as a team to achieve the best possible outcomes.
                </p>
              </div>
              
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-tertiary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-2xl text-white">📚</span>
                </div>
                <h3 className="text-xl font-semibold mb-2">Continuous Learning</h3>
                <p className="text-muted-foreground">
                  We invest in our team's growth and stay current with the latest industry trends.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Testimonials Section */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-6">What Our Clients Say</h2>
            <p className="text-lg text-muted-foreground">
              Don't just take our word for it. Here's what our clients have to say about working with WizMark.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <Card className="text-center hover:shadow-lg transition-shadow">
              <CardContent className="p-6">
                <div className="flex justify-center mb-4">
                  <div className="flex space-x-1">
                    {[...Array(5)].map((_, i) => (
                      <span key={i} className="text-yellow-400 text-lg">★</span>
                    ))}
                  </div>
                </div>
                <p className="text-muted-foreground mb-6 italic">
                  "WizMark transformed our digital presence completely. Their mobile app increased our customer engagement by 200%. The team is professional and delivers on time."
                </p>
                <div className="flex items-center justify-center space-x-3">
                  <img
                    src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=60"
                    alt="Client"
                    className="w-12 h-12 rounded-full object-cover"
                  />
                  <div>
                    <p className="font-semibold">Jennifer Martinez</p>
                    <p className="text-sm text-muted-foreground">CEO, TechFlow Solutions</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="text-center hover:shadow-lg transition-shadow">
              <CardContent className="p-6">
                <div className="flex justify-center mb-4">
                  <div className="flex space-x-1">
                    {[...Array(5)].map((_, i) => (
                      <span key={i} className="text-yellow-400 text-lg">★</span>
                    ))}
                  </div>
                </div>
                <p className="text-muted-foreground mb-6 italic">
                  "Outstanding web development and SEO services. Our organic traffic increased by 150% within 6 months. Highly recommend WizMark for any digital project."
                </p>
                <div className="flex items-center justify-center space-x-3">
                  <img
                    src="https://images.unsplash.com/photo-1560250097-0b93528c311a?w=60"
                    alt="Client"
                    className="w-12 h-12 rounded-full object-cover"
                  />
                  <div>
                    <p className="font-semibold">Robert Anderson</p>
                    <p className="text-sm text-muted-foreground">Founder, GreenTech Innovations</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="text-center hover:shadow-lg transition-shadow">
              <CardContent className="p-6">
                <div className="flex justify-center mb-4">
                  <div className="flex space-x-1">
                    {[...Array(5)].map((_, i) => (
                      <span key={i} className="text-yellow-400 text-lg">★</span>
                    ))}
                  </div>
                </div>
                <p className="text-muted-foreground mb-6 italic">
                  "The AI solutions provided by WizMark revolutionized our business processes. Their expertise and support throughout the project was exceptional."
                </p>
                <div className="flex items-center justify-center space-x-3">
                  <img
                    src="https://images.unsplash.com/photo-1580489944761-15a19d654956?w=60"
                    alt="Client"
                    className="w-12 h-12 rounded-full object-cover"
                  />
                  <div>
                    <p className="font-semibold">Maria Silva</p>
                    <p className="text-sm text-muted-foreground">CTO, DataVision Corp</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* Join Team CTA */}
      <section className="py-20 bg-gradient-primary">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            Want to Join Our Team?
          </h2>
          <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            We're always looking for talented individuals who share our passion for technology 
            and innovation. Check out our current openings or get in touch.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" variant="secondary" asChild>
              <a href="/careers">View Open Positions</a>
            </Button>
            <Button size="lg" variant="outline" className="text-white border-white hover:bg-white hover:text-primary">
              Send Your Resume
            </Button>
          </div>
        </div>
      </section>
    </div>
  )
}