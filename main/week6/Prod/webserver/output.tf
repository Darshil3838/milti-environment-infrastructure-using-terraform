#Add output variables for private_subnet_prod webserver1
output "private_ip_1_prod" {
  value = aws_instance.wsp1.private_ip

}






#Add output variables for private_subnet_prod webserer2
output "private_ip_2_prod" {

  value = aws_instance.wsp2.private_ip
}


