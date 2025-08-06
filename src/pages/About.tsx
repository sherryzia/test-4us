import { Users, Target, Lightbulb, Award } from "lucide-react"
import { Card, CardContent } from "@/components/ui/card"

const values = [
  {
    icon: Lightbulb,
    title: "Innovation",
    desc: "We stay ahead of technology trends to deliver cutting-edge solutions that give our clients a competitive edge."
  },
  {
    icon: Users,
    title: "Collaboration",
    desc: "We work closely with our clients as partners, ensuring their vision is realized through transparent communication."
  },
  {
    icon: Target,
    title: "Excellence",
    desc: "We maintain the highest standards of quality in every project, delivering solutions that exceed expectations."
  },
  {
    icon: Award,
    title: "Reliability",
    desc: "Our clients trust us to deliver on time and on budget, with ongoing support for long-term success."
  }
]

const stats = [
  { number: "500+", label: "Projects Completed" },
  { number: "200+", label: "Happy Clients" },
  { number: "5+", label: "Years Experience" },
  { number: "24/7", label: "Support Available" }
]

export default function About() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-hero">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h1 className="text-4xl md:text-5xl font-bold mb-6">About WizMark</h1>
            <p className="text-xl text-muted-foreground">
              We're a passionate team of innovators, designers, and developers dedicated to 
              transforming ideas into powerful digital solutions that drive business success.
            </p>
          </div>
        </div>
      </section>

      {/* Mission & Vision */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <h2 className="text-3xl md:text-4xl font-bold mb-6">Our Mission</h2>
              <p className="text-lg text-muted-foreground mb-6">
                To empower businesses with innovative technology solutions that drive growth, 
                enhance user experiences, and create lasting competitive advantages in the digital landscape.
              </p>
              <p className="text-lg text-muted-foreground">
                We believe in the transformative power of technology and are committed to making 
                advanced digital solutions accessible to businesses of all sizes.
              </p>
            </div>
            <div className="bg-gradient-primary p-8 rounded-xl text-white">
              <h3 className="text-2xl font-bold mb-4">Our Vision</h3>
              <p className="text-lg">
                To be the leading technology partner that businesses trust to navigate 
                the digital future, creating solutions that not only meet today's needs 
                but anticipate tomorrow's opportunities.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Values */}
      <section className="py-20 bg-muted/50">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">Our Values</h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              The principles that guide our work and define our relationships with clients
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {values.map((value, index) => (
              <Card key={value.title} className="text-center hover:shadow-lg transition-shadow">
                <CardContent className="p-6">
                  <div className="mb-4 flex justify-center">
                    <value.icon className="h-12 w-12 text-primary" />
                  </div>
                  <h3 className="text-xl font-semibold mb-3">{value.title}</h3>
                  <p className="text-muted-foreground">{value.desc}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Stats */}
      <section className="py-20 bg-gradient-secondary">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">Our Impact</h2>
            <p className="text-xl text-white/90 max-w-2xl mx-auto">
              Numbers that showcase our commitment to delivering exceptional results
            </p>
          </div>

          <div className="grid grid-cols-2 lg:grid-cols-4 gap-8">
            {stats.map((stat, index) => (
              <div key={stat.label} className="text-center">
                <div className="text-4xl md:text-5xl font-bold text-white mb-2">
                  {stat.number}
                </div>
                <div className="text-white/80">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Story */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold mb-8 text-center">Our Story</h2>
            <div className="prose prose-lg max-w-none">
              <p className="text-lg text-muted-foreground mb-6">
                Founded with a vision to bridge the gap between cutting-edge technology and 
                practical business solutions, WizMark has grown from a small team of passionate 
                developers to a comprehensive digital solutions provider.
              </p>
              <p className="text-lg text-muted-foreground mb-6">
                Our journey began when we recognized that many businesses were struggling to 
                keep pace with rapid technological advancements. We set out to create a company 
                that could not only build exceptional digital products but also guide our 
                clients through their digital transformation journey.
              </p>
              <p className="text-lg text-muted-foreground">
                Today, we're proud to serve clients across various industries, from startups 
                looking to make their mark to established enterprises seeking to innovate and 
                evolve. Our multidisciplinary approach ensures that every solution we create 
                is not just technically sound but also strategically aligned with our clients' 
                business objectives.
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}