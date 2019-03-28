# GenieACS v1.1.3 Dockerfile #
##############################

# Dockerfile of node:8-stretch here: https://github.com/nodejs/docker-node/blob/526c6e618300bdda0da4b3159df682cae83e14aa/8/stretch/Dockerfile
FROM node:8-stretch
LABEL maintainer="acsdesk@protonmail.com"

RUN apt-get update && apt-get install -y sudo apt-transport-https apt-utils supervisor
RUN mkdir -p /var/log/supervisor

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y
RUN yarn global add genieacs@1.1.3 --exact
RUN ln -s /usr/local/share/.config/yarn/global/node_modules/genieacs /opt

## Change config.json ##
WORKDIR /opt/genieacs/config
RUN openssl genrsa 2048 > cwmp.key
RUN openssl req -new -x509 -days 10000 -key cwmp.key -subj "/C=ES/O=ACSdesk/emailAddress=acsdesk@protonmail.com" > cwmp.crt
RUN cp cwmp.crt nbi.crt && cp cwmp.key nbi.key && cp cwmp.crt fs.crt && cp cwmp.key fs.key
#RUN sed -i 's/mongodb:\/\/127.0.0.1\/genieacs/mongodb:\/\/user:password@127.0.0.1\/genieacs/' config.json
RUN sed -i 's/mongodb:\/\/127.0.0.1\/genieacs/mongodb:\/\/mongo\/genieacs/' config.json
RUN sed -i 's/acs.example.com/acs.local/' config.json
RUN sed -i '0,/false/ s/false/true/' config.json ## Changes first occurence of "false" in SSL on CWMP
#RUN sed -i '8i\ \ "NBI_SSL" : true,' config.json
#RUN sed -i '12i\ \ "FS_SSL" : true,' config.json

# Install GenieACS-GUI #
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN rbenv install 2.6.2
RUN rbenv global 2.6.2
RUN rbenv rehash

RUN echo "gem: --no-document" > ~/.gemrc
WORKDIR /opt/
RUN git clone https://github.com/genieacs/genieacs-gui
WORKDIR /opt/genieacs-gui/config
RUN cp graphs-sample.json.erb graphs.json.erb
RUN cp index_parameters-sample.yml index_parameters.yml 
RUN cp summary_parameters-sample.yml summary_parameters.yml
RUN cp parameters_edit-sample.yml parameters_edit.yml
RUN cp parameter_renderers-sample.yml parameter_renderers.yml 
RUN cp roles-sample.yml roles.yml 
RUN cp users-sample.yml users.yml

RUN /root/.rbenv/shims/gem install bundler
RUN /root/.rbenv/shims/bundle
RUN /root/.rbenv/shims/gem install rails
WORKDIR /opt/genieacs-gui
RUN grep -rl "ActiveRecord::Migration$" db | xargs sed -i 's/ActiveRecord::Migration/ActiveRecord::Migration[5.2]/g'
RUN /root/.rbenv/shims/rails db:migrate RAILS_ENV=development

WORKDIR /opt
RUN git clone https://github.com/DrumSergio/genieacs-services
RUN cp genieacs-services/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
