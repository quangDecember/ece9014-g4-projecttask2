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

CREATE TABLE forummessages_TB (
          
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

CREATE TABLE forummessagesvote_TB (
          
   ForumVoteID      INT,
   Votedate VARCHAR(20),
   Message int,
   Medal int,
   CONSTRAINT forumvote_PK PRIMARY KEY (ForumVoteID)  
);



CREATE TABLE tags_TB (
          
tagid      INT,
supertagid int, 
-- datasetid      INT,
Description varchar(20),
-- DatasetCount int,
-- CompetitionCount int, 
-- KernelCount int,
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
-- TotalKernels int,
datasourceid int,
   CONSTRAINT datasetid_PK PRIMARY KEY (datasetid),
/*add contrainst for users and kernel versions*/
  CONSTRAINT dataset_FK FOREIGN KEY (tagid) REFERENCES tags_tb(tagid)
);

-- ALTER TABLE tags_TB
-- add CONSTRAINT tags_FK FOREIGN KEY (datasetid) REFERENCES datasets_tb(datasetid);

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
	ADD CONSTRAINT dataset_FK2 FOREIGN KEY (datasourceid) REFERENCES datasetsources_TB (datasourceId);

DESC forummessages_TB;
    
CREATE TABLE FORUMMESSAGEVOTES (
FMVid INT NOT NULL,
ForumMessageId INT NOT NULL references forummessages_TB(ForumMID),
FromUserId INT NOT NULL,
ToUserId INT NOT NULL,
VoteDate Date,
PRIMARY KEY (FMVid,ForumMessageId,FromUserId,ToUserId)
);
-- needs USER table for references

CREATE TABLE DATASETVOTES(
DatasetVoteId INT NOT NULL,
UserId INT NOT NULL,
DatasetVersionId INT NOT NULL references datasetversions_TB(datasetvid),
VoteDate date,
primary key (DatasetVoteId,UserId,DatasetVersionId)
);
-- needs USER table as well

CREATE TABLE COMPETITION(
CompetitionId INT NOT NULL PRIMARY KEY,
Title VARCHAR(255),
CompetitionTypeId INT,
Subtitle MEDIUMTEXT,
ForumID INT not null references forum_TB(ForumID),
OrganizationID INT not null, -- missing references
HostName varchar(255),
EnabledDate datetime,
Deadline datetime,
TotalTeams int,
TotalCompetitors int,
TotalSubmission int,
OnlyAllowKernelSubmission bool,
check (CompetitionTypeId = 1 or CompetitionTypeId = 2)
);
CREATE TABLE COMPETITIONTAGS (
competitionTagId INT NOT NULL,
CompetitionId INT NOT NULL references COMPETITION(CompetitionId),
TagId INT not null references tags_TB(tagid),
PRIMARY KEY (competitionTagId,CompetitionId,TagId)
);


CREATE TABLE USERS (
    userId	INT	NOT NULL,
    UserName	NVARCHAR (50) ,
    DisplayName	VARCHAR (50),
    RegisterDate DATE NOT NULL DEFAULT (CURRENT_DATE), -- SYSDATE -- is Oracle
    PerformanceTier	INT	,
    CONSTRAINT user_PK PRIMARY KEY (userId)  
);


CREATE TABLE LANGUAGES (
    languageId INT NOT NULL,
    languageName VARCHAR (30) NOT NULL,
    DisplayName	VARCHAR (10) NOT NULL,
    IsNotebook INT(1) default 0 NOT NULL,
    CONSTRAINT language_PK PRIMARY KEY (languageId),
    CONSTRAINT language_BOOL_IsNotebook CHECK (IsNotebook IN (0,1))
);


CREATE TABLE ORGANIZATIONS (
    orgId INT NOT NULL,
    orgName	NVARCHAR (50) NOT NULL,
    Slug VARCHAR (20) NOT NULL,
    CreationDate DATE  DEFAULT (CURRENT_DATE) NOT NULL,
    Description NVARCHAR (500),
    CONSTRAINT organization_PK PRIMARY KEY (orgId)
);

CREATE TABLE TEAMS (
     teamId	INT	NOT NULL,
    CompetitionId	INT	NOT NULL,
    TeamLeaderId	INT	,
    TeamName	NVARCHAR(50)	,
    ScoreFirstSubmittedDate	DATE	, -- should be derived but insufficient data available
    -- LastSubmissionDate	DATE	, -- [DERIVED]
    PublicLeaderboardSubmissionId	INT	,
    PrivateLeaderboardSubmissionId	INT	,
    IsBenchmark	BOOLEAN	,
    Medal	BOOLEAN	,
    MedalAwardDate	DATE	,
    PublicLeaderboardRank	INT	,
    PrivateLeaderboardRank	INT	,
    CONSTRAINT team_PK PRIMARY KEY (teamId) ,
    CONSTRAINT team_FK_leader FOREIGN KEY (TeamLeaderId) REFERENCES USERS(userId) ,
    CONSTRAINT team_FK_Competition FOREIGN KEY (CompetitionId) REFERENCES COMPETITION(CompetitionId),
    CONSTRAINT team_BOOL_IsBenchmark CHECK (IsBenchmark is null or IsBenchmark IN (0,1))
); 

CREATE TABLE KERNELS (
     scriptId	INT 	NOT NULL,
    AuthorId	INT 	NOT NULL,
    CurrentKernelVersionId	INT 	,
    ForkParentKernelVersionId	INT 	,
    ForumTopicId	INT 	,
    FirstKernelVersionId	INT 	,
    CreationDate	DATE	,
    EvaluationDate	DATE	,
    MadePublicDate	DATE	,
    IsProjectLanguageTemplate	BOOLEAN	,
    CurrentUrlSlug	VARCHAR (20)	,
    Medal	BOOLEAN,
    MedalAwardDate	DATE	,
    
    /* DERIVED:
    TotalViews	INT 	,
    TotalComments	INT 	,
    TotalVotes	INT 	,
    */
    
    CONSTRAINT kernel_PK PRIMARY KEY (scriptId) ,    
    CONSTRAINT kernel_FK_Author FOREIGN KEY (AuthorId) REFERENCES USERS(userId) ,
    CONSTRAINT kernel_BOOL_IsProjectLanguageTemplate 
        CHECK (IsProjectLanguageTemplate is null or IsProjectLanguageTemplate IN (0,1))
);

CREATE TABLE KERNEL_VERSIONS (
 	kvId	INT	NOT NULL,	
	ScriptId	INT	NOT NULL,	
	ParentKVID	INT	,	
	languageId	INT	NOT NULL,	
	AuthorId	INT	NOT NULL,	
	CreationDate	DATE default (CURRENT_DATE) NOT NULL,	
	VersionNumber	INT	,	
	Title	VARCHAR (50)	,	
	EvaluationDate	DATE	,	
	IsChange	BOOLEAN	,	
	TotalLines	INT	,	
	LinesInsertedFromPrevious	INT	,	
	LinesChangedFromPrevious	INT	,	
	LinesUnchangedFromPrevious	INT	,	
	LinesInsertedFromFork	INT	,	
	LinesDeletedFromFork	INT	,	
	LinesChangedFromFork	INT	,	
	LinesUnchangedFromFork	INT	,	
	-- TotalVotes	INT	,	  --[DERIVED]
    CONSTRAINT kernelVersions_PK PRIMARY KEY (kvId) ,    
    CONSTRAINT kernelVersions_FK_Author FOREIGN KEY (AuthorId) REFERENCES USERS(userId) ,
    CONSTRAINT kernelVersions_FK_Parent FOREIGN KEY (ParentKVID) REFERENCES KERNEL_VERSIONS(kvId) ,
    CONSTRAINT kernelVersions_FK_Language FOREIGN KEY (languageId) REFERENCES LANGUAGES(languageId) ,
    CONSTRAINT kernelVersions_BOOL_IsChange CHECK (IsChange is null or IsChange IN (0,1))
);

CREATE TABLE KERNEL_VERSION_DATASET_SOURCES (
    kvdsId INT NOT NULL,
    kvId INT NOT NULL,
    datasetvid INT NOT NULL,
    CONSTRAINT KERNEL_VERSION_DATASET_SOURCES_PK PRIMARY KEY (kvdsId) ,
    CONSTRAINT KERNEL_VERSION_DATASET_SOURCES_FK_kv FOREIGN KEY (kvId) REFERENCES KERNEL_VERSIONS(kvId) ,
    CONSTRAINT KERNEL_VERSION_DATASET_SOURCES_FK_datasetvid FOREIGN KEY (datasetvid) REFERENCES datasetversions_TB(datasetvid) ,
    CONSTRAINT KERNEL_VERSION_DATASET_SOURCES_UNIQUE UNIQUE(kvId,datasetvid) 
);

CREATE TABLE KERNEL_TAGS (
    kernelTagId INT NOT NULL,
    scriptId INT NOT NULL,
    tagid INT NOT NULL,
    CONSTRAINT KERNEL_TAGS_PK PRIMARY KEY (kernelTagId) ,
    CONSTRAINT KERNEL_TAGS_FK_kv FOREIGN KEY (scriptId) REFERENCES KERNELS(scriptId) ,
    CONSTRAINT KERNEL_TAGS_FK_tag FOREIGN KEY (tagid) REFERENCES tags_TB(tagid) ,
    CONSTRAINT KERNEL_TAGS_UNIQUE UNIQUE(scriptId,tagid) 
);

CREATE TABLE KERNEL_VOTES (
    kernelVoteId INT NOT NULL,
    kvId INT NOT NULL,
    userId INT NOT NULL,
    CONSTRAINT kernelVote_PK PRIMARY KEY (kernelVoteId) ,
    CONSTRAINT kernelVote_FK_kv FOREIGN KEY (kvId) REFERENCES KERNEL_VERSIONS(kvId) ,
    CONSTRAINT kernelVote_FK_voter FOREIGN KEY (userId) REFERENCES USERS(userId) ,
    CONSTRAINT kernelVote_UNIQUE UNIQUE(kvId,userId) 
);

CREATE TABLE USER_ACHIEVEMENTS (
	achievementId	INT	NOT NULL,	
	userId	INT	NOT NULL,	
	AchievementType	VARCHAR (20)	NOT NULL,	
	AchievementTier	BOOLEAN	NOT NULL,	
	TierAchievementDate	DATE	,	
	Points	INT	NOT NULL,
    
    -- should technically be derived, but we have insufficient data
	CurrentRanking	INT	,	
	HighestRanking	INT	,	
	TotalGold	INT	NOT NULL,	
	TotalSilver	INT	NOT NULL,	
	TotalBronze	INT	NOT NULL,
    
    CONSTRAINT USER_ACHIEVEMENTS_PK PRIMARY KEY (achievementId) ,
    CONSTRAINT USER_ACHIEVEMENTS_FK_user FOREIGN KEY (userId) REFERENCES USERS(userId) 
);

CREATE TABLE TEAM_MEMBERSHIPS (
    membershipId INT NOT NULL,
    teamId INT NOT NULL,
    userId INT NOT NULL,
    requestDate DATE default (CURRENT_DATE) NOT NULL,
    CONSTRAINT TEAM_MEMBERSHIPS_PK PRIMARY KEY (membershipId) ,
    CONSTRAINT TEAM_MEMBERSHIPS_FK_team FOREIGN KEY (teamId) REFERENCES TEAMS(teamId) ,
    CONSTRAINT TEAM_MEMBERSHIPS_FK_member FOREIGN KEY (userId) REFERENCES USERS(userId) ,
    CONSTRAINT TEAM_MEMBERSHIPS_UNIQUE UNIQUE(teamId,userId) 
);

CREATE TABLE SUBMISSIONS (
    submissionId	INT	NOT NULL,	
	userId	INT	,	
	teamId	INT	NOT NULL,	
	SourceKernelVersionId	INT	,	
	SubmissionDate	DATE	default sysdate NOT NULL,	
	ScoreDate	DATE	,	
	-- IsAfterDeadline	NUMBER (1)	NOT NULL,	[DERIVED]
	PublicScoreLeaderboardDisplay	NUMBER (5,5)	,	
	PublicScoreFullPrecision	NUMBER	,	
	PrivateScoreLeaderboardDisplay	NUMBER (5,5)	,	
	PrivateScoreFullPrecision	NUMBER	,	
    CONSTRAINT submissions_PK PRIMARY KEY (submissionId) ,
    CONSTRAINT submissions_FK_team FOREIGN KEY (teamId) REFERENCES TEAMS(teamId) ,
    CONSTRAINT submissions_FK_userId FOREIGN KEY (userId) REFERENCES USERS(userId) ,
    CONSTRAINT submissions_FK_kvId FOREIGN KEY (SourceKernelVersionId) REFERENCES KERNEL_VERSIONS(kvId)
);

CREATE TABLE USER_ORGANIZATIONS (
    orgMemberId INT NOT NULL,
    orgId INT NOT NULL,
    userId INT NOT NULL,
    CONSTRAINT UserOrganizations_PK PRIMARY KEY (orgMemberId) ,
    CONSTRAINT UserOrganizations_FK_org FOREIGN KEY (orgId) REFERENCES ORGANIZATIONS(orgId) ,
    CONSTRAINT UserOrganizations_FK_member FOREIGN KEY (userId) REFERENCES USERS(userId) ,
    CONSTRAINT UserOrganizations_UNIQUE UNIQUE(orgId,userId) 
);

CREATE TABLE USER_FOLLOWERS (
    followId INT NOT NULL,
    userId INT NOT NULL,
    followingUserId INT NOT NULL,
    creationDate DATE default sysdate NOT NULL,
    CONSTRAINT UserFollowers_PK PRIMARY KEY (followId) ,
    CONSTRAINT UserFollowers_FK_user FOREIGN KEY (userId) REFERENCES USERS(userId) ,
    CONSTRAINT UserFollowers_FK_follower FOREIGN KEY (followingUserId) REFERENCES USERS(userId) ,
    CONSTRAINT UserFollowers_UNIQUE UNIQUE(userId,followingUserId) 
);

