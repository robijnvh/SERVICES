cd /www

wp config create --dbname=wordpress --dbuser=mysql --dbpass=ft_services --dbhost=mysql
wp db create
wp core install --url=192.168.99.220:5050 --title=Wordpress\ for\ ft_services --admin_user=rvan-hou --admin_password=ft_services --admin_email=rvan-hou@student.codam.nl --skip-email
wp user create test1 test1@student.codam.nl --user_pass=test1 --role=author
wp user create test2 test2@student.codam.nl --user_pass=test2 --role=author
wp user create test3 test3@student.codam.nl --user_pass=test3 --role=subscriber


wp theme install https://downloads.wordpress.org/theme/twentytwenty.1.6.zip --path=/www
wp theme activate twentytwenty --path=/www

php-fpm7
nginx

while true; do
	sleep 5
	ps | grep nginx | grep master
	if [ $? == 1 ]; then break
	fi
	ps | grep php-fpm | grep master
	if [ $? == 1 ]; then break
	fi
done