output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.alb_web.dns_name
}
