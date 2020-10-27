/*unary relationship with itself*/
CREATE TABLE forum_TB (
          
   ForumID    INT,
   ParentForumID INT,
   Title varchar(20),
   CONSTRAINT forumt_PK PRIMARY KEY (ForumID)  
);


ALTER TABLE forum_TB
add CONSTRAINT forum_FK FOREIGN KEY (ParentForumID) REFERENCES forum_TB(ForumID);

CREATE TABLE forumtopics_TB (
          
  Forumtid      int,
  forumid       int,
  Creationdate     VARCHAR(20),
  DisplayName      VARCHAR(10),
 -- LastCommentDate  Varchar(10),
 -- TotalMessages    int,
 -- totalviews       int,
  score            int,
  CONSTRAINT forumtopics_PK PRIMARY KEY (Forumtid),
  CONSTRAINT forumtopics_FK1 FOREIGN KEY (forumid) REFERENCES forum_TB(ForumID)

);

CREATE TABLE forummessgaes_TB (
          
   ForumMID      INT,
  forumm int,
   UserId VARCHAR(20),
   Postdate VARCHAR(10),
   ReplyToForumMessageId Varchar(10),
   Message int,
   Medal int,
   CONSTRAINT forummessages_PK PRIMARY KEY (ForumMID) , 
  CONSTRAINT forummessages_FK1 FOREIGN KEY (forummid) REFERENCES forumtopics_TB(Forumtid)
  /*ADD CONTRAINST FOR USER AS WELL*/
);

CREATE TABLE forummessgaesvote_TB (
          
   ForumVoteID      INT,
   Votedate VARCHAR(20),
   Message int,
   Medal int,
   CONSTRAINT forumvote_PK PRIMARY KEY (ForumVoteID)  
);



CREATE TABLE tags_TB (
          
tagid      INT,
supertagid int, 
--datasetid      INT,
Description varchar(20),
--DatasetCount int,
--CompetitionCount int, 
--KernelCount int,
   CONSTRAINT tag_PK PRIMARY KEY (tagid)
  
  /*add contrainst for kernels , competitions*/
);
ALTER TABLE tags_TB
add CONSTRAINT tags_FK1 FOREIGN KEY (supertagid) REFERENCES tags_TB(tagid);




CREATE TABLE datasets_TB (
          
datasetid      INT,
tagid int,
CreatorUserId int,
OwnerUserId int,
OwnerOrganizationId int, 
CurrentDatasetVersionId int,
Kernelid int,
--TotalKernels int,
datasourceid int,
   CONSTRAINT datasetid_PK PRIMARY KEY (datasetid),
/*add contrainst for users and kernel versions*/
  CONSTRAINT dataset_FK FOREIGN KEY (tagid) REFERENCES tags_tb(tagid)
);

--ALTER TABLE tags_TB
--add CONSTRAINT tags_FK FOREIGN KEY (datasetid) REFERENCES datasets_tb(datasetid);

CREATE TABLE datasetversions_TB (
          
datasetvid int,
DatasetId int,
CreatorUserId varchar(20),
CreationDate varchar(20),
Title varchar(20),
Subtitle varchar(20),
Description  varchar(20),
VersionNotes varchar(20),
TotalCompressedBytes int,
   CONSTRAINT datasetvid_PK PRIMARY KEY (datasetvid),
/*add contrainst for users */
  CONSTRAINT datasetversion_FK FOREIGN KEY (DatasetId) REFERENCES datasets_tb(datasetid)
);

CREATE TABLE datasetsources_TB (
          
datasourceId int , 
CreatorUserId int,
CreationDate varchar(20),
CurrentDatasourceVersionId int,
CONSTRAINT datasourceid_PK PRIMARY KEY (datasourceid)
  );

ALTER TABLE datasets_TB
add CONSTRAINT dataset_FK2 FOREIGN KEY (datasourceid) REFERENCES datasetsources_TB(datasourceId);
