import { MapPin, Clock, Briefcase, Users, Heart, Zap } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

const openPositions = [
  {
    id: 1,
    title: "Senior React Developer",
    department: "Engineering",
    type: "Full-time",
    location: "Remote / New York",
    experience: "5+ years",
    description: "We're looking for a Senior React Developer to join our growing engineering team. You'll be responsible for building scalable web applications and mentoring junior developers.",
    requirements: [
      "5+ years of React.js experience",
      "Strong TypeScript and JavaScript skills",
      "Experience with Node.js and REST APIs",
      "Knowledge of modern development tools and practices",
      "Excellent communication and teamwork skills"
    ],
    posted: "2 days ago"
  },
  {
    id: 2,
    title: "Mobile App Developer (Flutter)",
    department: "Engineering",
    type: "Full-time",
    location: "Remote / San Francisco",
    experience: "3+ years",
    description: "Join our mobile team to create beautiful, performant cross-platform applications using Flutter. You'll work on exciting projects for various industries.",
    requirements: [
      "3+ years of Flutter/Dart experience",
      "Experience with native iOS/Android development",
      "Knowledge of mobile app architecture patterns",
      "Experience with CI/CD pipelines",
      "Strong problem-solving skills"
    ],
    posted: "1 week ago"
  },
  {
    id: 3,
    title: "Digital Marketing Specialist",
    department: "Marketing",
    type: "Full-time",
    location: "Remote / Los Angeles",
    experience: "2+ years",
    description: "We're seeking a creative Digital Marketing Specialist to develop and execute marketing campaigns across various digital channels.",
    requirements: [
      "2+ years of digital marketing experience",
      "Experience with Google Ads, Facebook Ads, and SEO",
      "Strong analytical and data interpretation skills",
      "Content creation and social media management experience",
      "Bachelor's degree in Marketing or related field"
    ],
    posted: "3 days ago"
  },
  {
    id: 4,
    title: "UX/UI Designer",
    department: "Design",
    type: "Full-time",
    location: "Remote / Austin",
    experience: "3+ years",
    description: "Create intuitive and beautiful user experiences for web and mobile applications. You'll work closely with our development team to bring designs to life.",
    requirements: [
      "3+ years of UX/UI design experience",
      "Proficiency in Figma, Sketch, or Adobe Creative Suite",
      "Strong understanding of user-centered design principles",
      "Experience with design systems and prototyping",
      "Portfolio demonstrating strong design skills"
    ],
    posted: "5 days ago"
  },
  {
    id: 5,
    title: "AI/ML Engineer",
    department: "Engineering",
    type: "Full-time",
    location: "Remote / Boston",
    experience: "4+ years",
    description: "Lead the development of AI-powered solutions for our clients. You'll work on cutting-edge machine learning projects and help shape our AI strategy.",
    requirements: [
      "4+ years of machine learning experience",
      "Strong Python programming skills",
      "Experience with TensorFlow, PyTorch, or similar frameworks",
      "Knowledge of cloud platforms (AWS, GCP, Azure)",
      "PhD in Computer Science, AI, or related field preferred"
    ],
    posted: "1 week ago"
  }
]

const benefits = [
  {
    icon: <Heart className="h-6 w-6" />,
    title: "Health & Wellness",
    description: "Comprehensive health insurance, dental, vision, and mental health support"
  },
  {
    icon: <Clock className="h-6 w-6" />,
    title: "Flexible Schedule",
    description: "Remote-first culture with flexible working hours and unlimited PTO"
  },
  {
    icon: <Zap className="h-6 w-6" />,
    title: "Growth & Learning",
    description: "Professional development budget, conferences, and continuous learning opportunities"
  },
  {
    icon: <Users className="h-6 w-6" />,
    title: "Team Culture",
    description: "Collaborative environment with regular team events and company retreats"
  }
]

export default function Careers() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-hero">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl md:text-5xl font-bold mb-6">Join Our Team</h1>
            <p className="text-xl text-muted-foreground mb-8">
              Be part of a innovative team that's shaping the future of technology. 
              We're always looking for talented individuals who share our passion for excellence.
            </p>
            <Button size="lg" variant="secondary">
              View Open Positions
            </Button>
          </div>
        </div>
      </section>

      {/* Why WizMark */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-6">Why Choose WizMark?</h2>
            <p className="text-lg text-muted-foreground">
              We believe that great work comes from great people in a great environment. 
              Here's what makes WizMark an exceptional place to work.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {benefits.map((benefit, index) => (
              <Card key={index} className="text-center hover:shadow-lg transition-shadow">
                <CardContent className="p-6">
                  <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center mx-auto mb-4 text-white">
                    {benefit.icon}
                  </div>
                  <h3 className="text-xl font-semibold mb-2">{benefit.title}</h3>
                  <p className="text-muted-foreground">{benefit.description}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Open Positions */}
      <section className="py-20 bg-muted/50">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold mb-12 text-center">Open Positions</h2>
            
            <div className="space-y-6">
              {openPositions.map((position) => (
                <Card key={position.id} className="hover:shadow-lg transition-shadow">
                  <CardHeader>
                    <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                      <div>
                        <CardTitle className="text-xl mb-2">{position.title}</CardTitle>
                        <div className="flex flex-wrap gap-2">
                          <Badge variant="secondary">{position.department}</Badge>
                          <Badge variant="outline">{position.type}</Badge>
                          <div className="flex items-center text-sm text-muted-foreground">
                            <MapPin className="h-4 w-4 mr-1" />
                            {position.location}
                          </div>
                          <div className="flex items-center text-sm text-muted-foreground">
                            <Briefcase className="h-4 w-4 mr-1" />
                            {position.experience}
                          </div>
                        </div>
                      </div>
                      <div className="text-sm text-muted-foreground">
                        Posted {position.posted}
                      </div>
                    </div>
                  </CardHeader>
                  
                  <CardContent>
                    <p className="text-muted-foreground mb-4">{position.description}</p>
                    
                    <div className="mb-6">
                      <h4 className="font-semibold mb-2">Requirements:</h4>
                      <ul className="list-disc list-inside space-y-1 text-sm text-muted-foreground">
                        {position.requirements.map((req, index) => (
                          <li key={index}>{req}</li>
                        ))}
                      </ul>
                    </div>
                    
                    <div className="flex flex-col sm:flex-row gap-3">
                      <Button>Apply Now</Button>
                      <Button variant="outline">Learn More</Button>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Contact CTA */}
      <section className="py-20 bg-gradient-secondary">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            Don't See a Perfect Match?
          </h2>
          <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            We're always interested in hearing from talented individuals. 
            Send us your resume and let's explore how you can contribute to our team.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" variant="secondary">
              Send Your Resume
            </Button>
            <Button size="lg" variant="outline" className="text-white border-white hover:bg-white hover:text-primary">
              Contact Us
            </Button>
          </div>
        </div>
      </section>
    </div>
  )
}