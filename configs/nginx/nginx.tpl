events {
  worker_connections  4096;  ## Default: 1024
}

http {
    upstream touchyfeely {
${join("\n", formatlist("\t\tserver %s;", split(",", upstream_list)))}
    }

    server {
        listen 80;

        location / {
            proxy_pass http://touchyfeely;
        }
    }
}