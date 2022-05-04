resource "aws_security_group" "kk-ssh-allowed" {
    vpc_id = "${aws_vpc.Main.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production.
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 9100
        to_port = 9100
        protocol = "tcp"
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production.
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGIX
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#bashchain host

resource "aws_instance" "bashchain-1" {
  instance_type = "t2.micro"
 # vpc_security_group_ids = "${aws_security_group.kk-ssh-allowed.id}" 
  associate_public_ip_address = true
  user_data = "${file("user-data.txt")}"
  key_name = "KTerraform"
  ami = "ami-0a3277ffce9146b74"
  subnet_id = "${aws_subnet.publicsubnets.id}"
  vpc_security_group_ids = [
  	aws_security_group.kk-ssh-allowed.id
  	]

  tags = {
       Name = "bashchain-1"
 } 
}

resource "aws_instance" "bashchain-2" {
  instance_type = "t2.micro"
 # vpc_security_group_ids = "${aws_security_group.kk-ssh-allowed.id}"
  associate_public_ip_address = true
  user_data = "${file("user-data.txt-1")}"
  key_name = "KTerraform"
  ami = "ami-0a3277ffce9146b74"
  subnet_id = "${aws_subnet.publicsubnets.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]

  tags = {
       Name = "bashchain-2"
 }
}


#private host

resource "aws_instance" "web-1" {
  instance_type = "t2.micro"
 # vpc_security_group_ids = "${aws_security_group.kk-ssh-allowed.id}"
  associate_public_ip_address = false
  user_data = "${file("user-data.txt")}"
  key_name = "kk-project"
  ami = "ami-0a3277ffce9146b74"
  subnet_id = "${aws_subnet.privatesubnets-2.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]

  tags = {
       Name = "web-1"
 }
}


resource "aws_instance" "web-2" {
  instance_type = "t2.micro"
 # vpc_security_group_ids = "${aws_security_group.kk-ssh-allowed.id}"
  associate_public_ip_address = false
  user_data = "${file("user-data.txt")}"
  key_name = "kk-project"
  ami = "ami-0a3277ffce9146b74"
  subnet_id = "${aws_subnet.privatesubnets-2.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]

  tags = {
       Name = "web-2"
 }
}



#private host-2

resource "aws_instance" "server-1" {
  instance_type = "t2.micro"
 # vpc_security_group_ids = "${aws_security_group.kk-ssh-allowed.id}"
  associate_public_ip_address = false
  user_data = "${file("user-data.txt")}"
  key_name = "kk-project"
  ami = "ami-0a3277ffce9146b74"
  subnet_id = "${aws_subnet.privatesubnets.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]

  tags = {
       Name = "server-1"
 }
}


resource "aws_instance" "server-2" {
  instance_type = "t2.micro"
 # vpc_security_group_ids = "${aws_security_group.kk-ssh-allowed.id}"
  associate_public_ip_address = false
  user_data = "${file("user-data.txt")}"
  key_name = "kk-project"
  ami = "ami-0a3277ffce9146b74"
  subnet_id = "${aws_subnet.privatesubnets.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]

  tags = {
       Name = "server-2"
 }
}
