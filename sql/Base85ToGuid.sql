/* Decodes a Base85 string (20 chars) to GUID (16 bytes) */
CREATE FUNCTION [Base85ToGuid]( @GUID VARCHAR(20) )
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	IF( @GUID IS NULL ) RETURN NULL;
	-- declare base85 encoding map (see http://rfc.zeromq.org/spec:32)
	-- NOTE: we replaced '&<>' with '~_;' (for better XML compatibility)
	DECLARE @decoding_map BINARY(96)= 0x00440054535248004B4C4641003F3E4500010203040506070809404A49424A47512425262728292A2B2C2D2E2F303132333435363738393A3B3C3D4D004E4349000A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122234F00504800;
	-- declare working variables
	DECLARE @output VARBINARY(16) = 0x;
	DECLARE @value BIGINT = 0;
	DECLARE @index INT = 0;
	-- walk the bytes (len hardcoded to 20)
	WHILE( @index < 20 )
	BEGIN
		-- build a 32-bit value from the bytes
		SET @index = @index + 1;
		SET @value = @value * 85 + CAST(SUBSTRING( @decoding_map, ASCII(SUBSTRING(@GUID, @index, 1)) - 32 + 1, 1) AS TINYINT );  
		-- for every 32 bits, convert the previous 4 bytes into 5 Ascii85 characters
		IF( @index % 5 = 0)
		BEGIN
			-- convert value to base 256
			DECLARE @divisor BIGINT = 256 * 256 * 256
			WHILE( @divisor > 0 )
			BEGIN 
				SET @output = @output + CAST(@value / @divisor % 256 AS BINARY(1));
				SET @divisor = @divisor / 256;
			END
			SET @value = 0;
		END
	END
	-- return the result of the function
	RETURN CAST(@output AS UNIQUEIDENTIFIER);
END


