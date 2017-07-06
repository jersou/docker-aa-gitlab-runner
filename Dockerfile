FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates wget apt-transport-https vim nano curl net-tools socat sudo acl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# docker
RUN curl -sSL https://get.docker.com/ | sh

# docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
	chmod +x /usr/local/bin/docker-compose

# gitlab-ci-multi-runner
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash
RUN apt-get install gitlab-ci-multi-runner

RUN usermod -aG docker gitlab-runner && \
    usermod -aG sudo   gitlab-runner

RUN mkdir -p /etc/sudoers.d/ && \
    echo "gitlab-runner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/gitlab-runner && \
    chmod 0440 /etc/sudoers.d/gitlab-runner

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]

ENTRYPOINT ["/etc/gitlab-runner/entrypoint.sh"]

CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]

