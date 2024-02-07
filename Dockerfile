FROM severynp/sftp-server:latest

# create data folders in the server
RUN mkdir /appdata

COPY data /appdata

# Create entrypoint script
ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
RUN mkdir /docker-entrypoint.d

# Sftp user credentials
RUN addgroup sftp 
RUN useradd titi
RUN echo "titi:pass" | chpasswd # pass defined as user password

# Add the user to sftp group :
RUN usermod -a -G sftp titi
RUN chown -R titi:sftp /appdata

RUN chmod 755 /appdata

# add sshd config
ADD sshd_config /etc/ssh/sshd_config

EXPOSE 22
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# RUN SSH in no daemon and expose errors to stdout
CMD [ "/usr/sbin/sshd", "-D", "-e" ]
