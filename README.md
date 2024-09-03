# httpoxy-scan
A minimal script to scan a website for the httpoxy vunerability - httpoxy.org

httpoxy is a set of vulnerabilities that affect application code running in CGI, or CGI-like environments. It comes down to a simple namespace conflict:

RFC 3875 (CGI) puts the HTTP Proxy header from a request into the environment variables as HTTP_PROXY
HTTP_PROXY is a popular environment variable used to configure an outgoing proxy
This leads to a remotely exploitable vulnerability. If you’re running PHP or CGI, you should block the Proxy header.
