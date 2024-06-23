# syntax = devthefuture/dockerfile-x
INCLUDE ./Dockerfile

########################################################################################################################
# SENDMAIL CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------
# The mhsendmail is a sendmail replacement for MailHog. It allows you to send mail from PHP through MailHog.
# This should only be installed in a development environment.
########################################################################################################################
# Install go
RUN apk add --no-cache go

# Install mhsendmail
RUN go install github.com/mailhog/mhsendmail@latest
RUN cp /root/go/bin/mhsendmail /usr/local/bin/mhsendmail
