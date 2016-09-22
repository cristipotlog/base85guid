# base85guid

SQL utility functions for converting GUID / UNIQUEIDENTIFIER (16 bytes) to Base85 string (20 chars) and back

Uses ZeroMQ implementation of Base85. See: http://rfc.zeromq.org/spec:32

> NOTE: we have replaced '&<>' with '~_;' (for better XML compatibility)

## GuidToBase85
Encodes a GUID (16 bytes) to Base85 string (20 chars)

## Base85ToGuid
Decodes a Base85 string (20 chars) to GUID (16 bytes)

# Release notes
- Sep 15, 2015: Initial commit
- Nov 18, 2015: Fixed buffer length issue
- Sep 22, 2016: Added convertion from chars to guid
