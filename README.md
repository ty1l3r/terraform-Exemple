- Le chemin de la clé public et privé ne doit pas se trouver dans le fichier projet.
- Complexité pour savoir ou mettre quoi ! (bastion est une instance EC2 mais a son propre module, Gestion des ALB et EC2 dans module séparé ajoute de la complexité mais est plus prpres ?)

ssh -i /home/ubuntu/project/key_rsa ec2-user@ec2-13-37-222-166.eu-west-3.compute.amazonaws.com

voir commande pour copier la clé ssh dans le bastion + chmod

#relancer les instances EC2 WP :
terraform taint module.alb.aws_launch_template.wordpress
terraform taint module.ec2.aws_autoscaling_group.asg
terraform apply

terraform taint module.ec2.aws_autoscaling_group.asg
terraform taint module.ec2.aws_autoscaling_attachment.asg_attachment
terraform taint module.ec2.aws_security_group.sg_private_wp
terraform taint module.rds.aws_db_instance.main
terraform taint module.rds.aws_db_subnet_group.db_subnet_group
terraform taint module.rds.aws_security_group.rds
terraform apply

terraform-20240913092921552900000005.cldawjkt00fr.eu-west-3.rds.amazonaws.com



ssh -i /home/ubuntu/project/key_rsa ec2-user@ec2-13-38-73-65.eu-west-3.compute.amazonaws.com


ssh -i /home/ec2-user/key_rsa ec2-user@10.0.2.16



---