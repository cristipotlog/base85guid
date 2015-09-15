/* Converts a GUID (16 bytes) to Base85 string (20 chars) */
CREATE FUNCTION [dbo].[BASE85GUID]( @GUID UNIQUEIDENTIFIER )
RETURNS VARCHAR(20)
AS
BEGIN
	IF( @GUID IS NULL ) RETURN NULL;
	-- declare base85 encoding map (see http://rfc.zeromq.org/spec:32)
	-- NOTE: we have replaced '&<>' with '~_;' (for better XML compatibility)
	DECLARE @encoding_map CHAR(85) = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?~_;()[]{}@%$#';
	-- convert guid to binary
	DECLARE @data BINARY(16) = CAST(@GUID AS BINARY(16));
	-- declare working variables
	DECLARE @output VARCHAR(20) = '';
	DECLARE @value BIGINT = 0;
	DECLARE @index INT = 0;
	-- walk the bytes
	WHILE( @index < LEN(@data) )
	BEGIN
		-- build a 32-bit value from the bytes
		SET @index = @index + 1;
		SET @value = @value * 256 + CAST(SUBSTRING(@data, @index, 1) AS TINYINT);		
		-- for every 32 bits, convert the previous 4 bytes into 5 Ascii85 characters
		IF( @index % 4 = 0)
		BEGIN
			-- convert value to Base85
			DECLARE @divisor BIGINT = 85 * 85 * 85 * 85
			WHILE( @divisor > 0 )
			BEGIN
				SET @output = @output + SUBSTRING(@encoding_map, @value / @divisor % 85 + 1, 1);
				SET @divisor = @divisor / 85;
			END
			SET @value = 0;
		END
	END
	-- Return the result of the function
	RETURN @output;
END

GO


