data "template_file" "inventory" {
    template = "${file("inventory.tpl")}"

    vars = {
        ec2_instance_public_ip    = "${join(",",module.ec2-instance.public_ip)}"
        ec2_instance_private_dns  = "${join(",",module.ec2-instance.private_dns)}"
    }
}

resource "null_resource" "update_inventory" {

    triggers = {
    	always_run = "${timestamp()}"
        template = "${data.template_file.inventory.rendered}"
    }
    provisioner "local-exec" {
        command = "echo '${data.template_file.inventory.rendered}' > ./inventory"

    }
}
