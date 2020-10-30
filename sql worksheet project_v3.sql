-- BATCH 1
CREATE TABLE USERS (
    userId	INT	NOT NULL,
    UserName	NVARCHAR2 (50) ,
    DisplayName	VARCHAR2 (50) ,
    RegisterDate	DATE default sysdate NOT NULL,
    PerformanceTier	NUMBER (2)	,
    CONSTRAINT user_PK PRIMARY KEY (userId)  
);

CREATE TABLE tags_TB (
          
tagid      INT NOT NULL,
supertagid int, 
-- datasetid      INT,
Description varchar(20),
-- DatasetCount int, --[DERIVED]
-- CompetitionCount int, --[DERIVED]
-- KernelCount int, --[DERIVED]
   CONSTRAINT tag_PK PRIMARY KEY (tagid)
  
  /*NO NEED to add contrainst for kernels , competitions AS THEY WILL ONLY BE IN VIEW/S*/
);
ALTER TABLE tags_TB
add CONSTRAINT tags_FK1 FOREIGN KEY (supertagid) REFERENCES tags_TB(tagid);



CREATE TABLE LANGUAGES (
    languageId INT NOT NULL,
    languageName VARCHAR2 (30) NOT NULL,
    DisplayName	VARCHAR2 (10) NOT NULL,
    IsNotebook NUMBER(1) default 0 NOT NULL,
    CONSTRAINT language_PK PRIMARY KEY (languageId),
    CONSTRAINT language_BOOL_IsNotebook CHECK (IsNotebook IN (0,1))
);

-- batch 2

CREATE TABLE ORGANIZATIONS (
    orgId INT NOT NULL,
    orgName	NVARCHAR2 (50) NOT NULL,
    Slug VARCHAR2 (20) NOT NULL,
    CreationDate DATE  default sysdate NOT NULL,
    Description NVARCHAR2 (500),
    CONSTRAINT organization_PK PRIMARY KEY (orgId)
);

CREATE TABLE forum_TB (
          
   ForumID    INT NOT NULL,
   ParentForumID INT,
   Title varchar(20),
   CONSTRAINT forumt_PK PRIMARY KEY (ForumID)  
);


ALTER TABLE forum_TB
add CONSTRAINT forum_FK FOREIGN KEY (ParentForumID) REFERENCES forum_TB(ForumID);


CREATE TABLE COMPETITION(
CompetitionId INT NOT NULL PRIMARY KEY,
Title VARCHAR(255),
CompetitionTypeId INT,
Subtitle CLOB,
ForumID INT not null references forum_TB(ForumID),
OrganizationID INT not null references ORGANIZATIONS(orgId),
HostName varchar(255),
EnabledDate date,
Deadline date,
--TotalTeams int, --[DERIVED]
--TotalCompetitors int,--[DERIVED]
--TotalSubmission int,--[DERIVED]
OnlyAllowKernelSubmission NUMBER(1) default (0) NOT NULL,
check (CompetitionTypeId = 1 or CompetitionTypeId = 2),
check (OnlyAllowKernelSubmission = 0 or OnlyAllowKernelSubmission = 1)
);


CREATE TABLE TEAMS (
     teamId	INT	NOT NULL,
    CompetitionId	INT	NOT NULL,
    TeamLeaderId	INT	,
    TeamName	NVARCHAR2 (50)	,
    ScoreFirstSubmittedDate	DATE	, --should be derived but insufficient data available
    --LastSubmissionDate	DATE	, --[DERIVED]
    PublicLeaderboardSubmissionId	INT	,
    PrivateLeaderboardSubmissionId	INT	,
    IsBenchmark	NUMBER (1)	,
    Medal	NUMBER (1)	,
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
    IsProjectLanguageTemplate	NUMBER (1)	,
    CurrentUrlSlug	VARCHAR2 (20)	,
    Medal	NUMBER (1)	,
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


CREATE TABLE datasets_TB (
          
datasetid      INT NOT NULL,
tagid int,
CreatorUserId int references USERS(USERID),
OwnerUserId int references USERS(USERID),
OwnerOrganizationId int references ORGANIZATIONS(ORGID), 
CurrentDatasetVersionId int, --FK constraint in next batch
Kernelid int,
-- TotalKernels int, --[DERIVED]
datasourceid int,
   CONSTRAINT datasetid_PK PRIMARY KEY (datasetid),
/*add contrainst for users and kernel versions*/
  CONSTRAINT dataset_FK1 FOREIGN KEY (tagid) REFERENCES tags_tb(tagid)
);


CREATE TABLE datasetsources_TB (
          
datasourceId int , 
CreatorUserId int,
CreationDate varchar(20),
CurrentDatasourceVersionId int,
CONSTRAINT datasourceid_PK PRIMARY KEY (datasourceid),
CONSTRAINT datasourceid_FK1 FOREIGN KEY (CreatorUserId) REFERENCES USERS(userId) 
  );




-- batch 3



CREATE TABLE forumtopics_TB (
          
  Forumtid      int not null,
  forumid       int not null,
  Creationdate     VARCHAR(20),
  DisplayName      VARCHAR(10),
  --LastCommentDate  DATE, --[DERIVED]
	--TotalMessages    int, --[DERIVED]
   totalviews       int,
  score            int,
  CONSTRAINT forumtopics_PK PRIMARY KEY (Forumtid),
  CONSTRAINT forumtopics_FK1 FOREIGN KEY (forumid) REFERENCES forum_TB(ForumID)

);


CREATE TABLE KERNEL_VERSIONS (
 	kvId	INT	NOT NULL,	
	ScriptId	INT	NOT NULL,	
	ParentKVID	INT	,	
	languageId	INT	NOT NULL,	
	AuthorId	INT	NOT NULL,	
	CreationDate	DATE default sysdate NOT NULL,	
	VersionNumber	INT	,	
	Title	VARCHAR2 (50)	,	
	EvaluationDate	DATE	,	
	IsChange	NUMBER(1)	,	
	TotalLines	INT	,	
	LinesInsertedFromPrevious	INT	,	
	LinesChangedFromPrevious	INT	,	
	LinesUnchangedFromPrevious	INT	,	
	LinesInsertedFromFork	INT	,	
	LinesDeletedFromFork	INT	,	
	LinesChangedFromFork	INT	,	
	LinesUnchangedFromFork	INT	,	
	--TotalVotes	INT	,	  --[DERIVED]
    CONSTRAINT kernelVersions_PK PRIMARY KEY (kvId) ,    
    CONSTRAINT kernelVersions_FK_Author FOREIGN KEY (AuthorId) REFERENCES USERS(userId) ,
    CONSTRAINT kernelVersions_FK_Parent FOREIGN KEY (ParentKVID) REFERENCES KERNEL_VERSIONS(kvId) ,
    CONSTRAINT kernelVersions_FK_Language FOREIGN KEY (languageId) REFERENCES LANGUAGES(languageId) ,
    CONSTRAINT kernelVersions_BOOL_IsChange CHECK (IsChange is null or IsChange IN (0,1))
);


CREATE TABLE datasetversions_TB (
          
datasetvid int not null,
DatasetId int,
CreatorUserId int not null references USERS(USERID),
CreationDate date,
Title varchar(20),
Subtitle varchar(20),
Description  varchar(20),
VersionNotes varchar(20),
TotalCompressedBytes int,
   CONSTRAINT datasetvid_PK PRIMARY KEY (datasetvid),

  CONSTRAINT datasetversion_FK FOREIGN KEY (DatasetId) REFERENCES datasets_tb(datasetid)
);


-- batch 4


CREATE TABLE USER_ACHIEVEMENTS (
	achievementId	INT	NOT NULL,	
	userId	INT	NOT NULL,	
	AchievementType	VARCHAR2 (20)	NOT NULL,	
	AchievementTier	NUMBER (1)	NOT NULL,	
	TierAchievementDate	DATE	,	
	Points	INT	NOT NULL,
    
    --should technically be derived, but we have insufficient data
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
    requestDate DATE default sysdate NOT NULL,
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
	--IsAfterDeadline	NUMBER (1)	NOT NULL,	[DERIVED]
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

-- batch 5

CREATE TABLE forummessages_TB (
          
   ForumMID      INT NOT NULL,
  forumTID int NOT NULL,
   UserId int REFERENCES USERS(USERID),
   Postdate DATE,
   ReplyToForumMessageId INT,
   Message NVARCHAR2(4000),
   Medal int,
   CONSTRAINT forummessages_PK PRIMARY KEY (ForumMID) , 
  CONSTRAINT forummessages_FK1 FOREIGN KEY (forumTID) REFERENCES forumtopics_TB(Forumtid),
  CONSTRAINT forummessages_FK2 FOREIGN KEY (forumTID) REFERENCES forumtopics_TB(Forumtid),
  CONSTRAINT forummessages_FK3 FOREIGN KEY (ReplyToForumMessageId) REFERENCES forummessages_TB(ForumMID)
  
);
						   
						   

CREATE TABLE Kernel_Version_DatasetSources (
    kvdssID INT NOT NULL,
    kvId INT NOT NULL,
    datasetvid INT NOT NULL,
    CONSTRAINT Kernel_Version_DatasetSources_PK PRIMARY KEY (kvdssID) ,
    CONSTRAINT Kernel_Version_DatasetSources_FK1 FOREIGN KEY (kvId) REFERENCES user_TB(userId) ,
    CONSTRAINT Kernel_Version_DatasetSources_FK2 FOREIGN KEY (datasetvid) REFERENCES user_TB(userId) ,
    CONSTRAINT Kernel_Version_DatasetSources_UNIQUE UNIQUE(kvId,datasetvid) 
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

CREATE TABLE COMPETITIONTAGS (
competitionTagId INT NOT NULL,
CompetitionId INT NOT NULL references COMPETITION(CompetitionId),
TagId INT not null references tags_TB(tagid),
PRIMARY KEY (competitionTagId),
unique(CompetitionId,TagId)
);

CREATE TABLE DATASETTAGS(
  datasetTagId INT NOT NULL,
  datasetId INT NOT NULL references DATASETS_TB(DATASETID),
  tagId INT NOT NULL references TAGS_TB(TAGID),
  CONSTRAINT DATASETTAGS_PK PRIMARY KEY (datasetTagId) ,
  CONSTRAINT DATASETTAGS_UNIQUE UNIQUE(datasetId,tagId) 
);


-- batch 6

CREATE TABLE DATASETVOTES(
DatasetVoteId INT NOT NULL,
UserId INT NOT NULL references USERS(USERID),
DatasetVersionId INT NOT NULL references datasetversions_TB(datasetvid),
VoteDate date,
primary key (DatasetVoteId),
unique(UserId,DatasetVersionId)
);

  
CREATE TABLE FORUMMESSAGEVOTES (
FMVid INT NOT NULL,
ForumMessageId INT NOT NULL references forummessages_TB(ForumMID),
FromUserId INT NOT NULL references USERS(USERID),
ToUserId INT NOT NULL references USERS(USERID),
VoteDate Date,
PRIMARY KEY (FMVid),
  unique(ForumMessageId,FromUserId,ToUserId)
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
