# base85guid

Utility function for converting GUID / UNIQUEIDENTIFIER (16 bytes) to Base85 string (20 chars)

Uses ZeroMQ implementation of Base85. See: http://rfc.zeromq.org/spec:32

> NOTE: we have replaced '&<>' with '~_;' (for better XML compatibility)

# Release notes
- Sep 15, 2015: Initial commit
- Nov 18, 2015: Fixed buffer length issue
