output "pub_sub_id" {
    value = aws_subnet.public.id
}

output "pub_sub_id_1" {
    value = aws_subnet.public-1.id
}

output "pvt_sub_id" {
    value = aws_subnet.private.id
}

output "pvt_sub_id_1" {
    value = aws_subnet.private-1.id
}