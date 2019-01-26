FROM hashicorp/terraform:0.11.11
ARG TFLINT_VERSION=v0.7.3

LABEL "com.github.actions.name"="terraform lint"
LABEL "com.github.actions.description"="Run terraform lint"
LABEL "com.github.actions.icon"="play-circle"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/team-lab/terraform-github-actions"
LABEL "homepage"="http://github.com/team-lab/terraform-github-actions"
LABEL "maintainer"="hayashitaiki@team-lab.com"

RUN apk --no-cache add jq
RUN curl -L -o tflint.zip https://github.com/wata727/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip && \
	unzip tflint.zip -d /usr/local/bin && \
	rm -f tflint.zip

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
