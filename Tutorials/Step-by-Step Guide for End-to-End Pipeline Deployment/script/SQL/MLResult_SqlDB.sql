CREATE TABLE [dbo].[MLResult] (
	[id] INT NOT NULL,
	[prediction] INT NOT NULL,
    CONSTRAINT [PK_MLResult] PRIMARY KEY CLUSTERED ( [id] ASC)
);
GO

CREATE TYPE [dbo].[MLResultType] 
AS TABLE(
	[id] INT NOT NULL,
	[prediction] INT NOT NULL
);
GO

CREATE PROCEDURE [dbo].[loadScoreResult]
      @MLResult MLResultType READONLY
AS
BEGIN
	SET NOCOUNT ON;
	MERGE MLResult AS target
		USING (SELECT * from @MLResult) AS source
		ON (target.id = source.id)
		WHEN MATCHED THEN 
			UPDATE SET prediction = source.prediction
		WHEN NOT MATCHED THEN
			INSERT (id, prediction)
			VALUES (source.id, source.prediction);

END;
Go