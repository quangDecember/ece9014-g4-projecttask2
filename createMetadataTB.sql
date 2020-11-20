create table KAGGLE_METADATA 
(
  id INT NOT NULL PRIMARY KEY,
  userId INT NOT NULL references USERS(USERID),
  competitionsId INT NOT NULL references COMPETITION(COMPETITIONID),
  forumsId INT NOT NULL references FORUM_TB(FORUMID),
  kernelId INT NOT NULL references KERNELS(scriptId),
  totalSubmissions INT,
  totalMedals INT,
  totalForumMessages INT,
  unique(userId,competitionsId,forumsId,kernelId)
);