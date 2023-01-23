# add public ip for bastian
output "public_b_server" {
  value = aws_instance.b_server.public_ip
}


#add private ip fror nonprod webser 1
output "privaet_ws1" {
  value = aws_instance.ws1.private_ip
}


#add public ip for webserver 2
output "privaet_ws2" {
  value = aws_instance.ws2.private_ip
}


