INSERT INTO DW.Competition(Title, TeamID, EnabledDate, DeadlineDate, OnlyAllowKernelSubmissions, TeamLeader,CompetitionId)
    (
        SELECT c.Title, t.teamID, c.EnabledDate, c.Deadline, c.OnlyAllowKernelSubmission, t.TeamLeader , c.CompetitionId
        FROM op.COMPETITION c, op.TEAMS t
        WHERE
            c.CompetitionId = t.CompetitionId
    );



INSERT INTO DW.Dataset(id,Title, Subtitle, OwnerUserId, CurrentDatasetVersionId)
    (
        SELECT datasetid, Title, Subtitle, OwnerUserId, CurrentDatasetVersionId
        FROM op.datasets_TB
        WHERE OwnerUserId is not null

    );

INSERT INTO DW.USERS(id,UserName, DisplayName, RegisterDate, PerformanceTier)
    (
        SELECT userId, UserName, DisplayName, RegisterDate, PerformanceTier
        FROM op.USERS
    );
      	

INSERT INTO DW.FORUM(FORUMID, Title, Creationdate, TopicID)
    (
        SELECT f.ForumID, f.Title, ft.Creationdate, ft.Forumtid
        FROM op.forum_TB f, op.forumtopics_TB ft
        WHERE
            f.ForumID = ft.forumid
    );

INSERT INTO DW.KERNEL(id, CreationDate, AuthorUserID, CurrentKernelVersionID, MadePublicDate)
    (
        SELECT scriptId, CreationDate, AuthorId, CurrentKernelVersionId, MadePublicDate
        FROM op.KERNELS
    )

INSERT INTO DW.PERFORMANCE_FACT(UsersID, CompetitionsID, ForumsID, KernelsID, TotalSubmissions, AvgScore, TotalMedals, TotalForumMessages)
    (
        select AA.user, AA.competition, BB.Forum, AA.kernel, AA.TotalSubmissions, AA.avgScore, BB.TotalMedals, BB.TotalMessages
        from 
        (
            select count(*) as TotalSubmissions , U.id as user, C.id as competition , K.id and kernel , AVG(S.PublicScoreFullPrecision) as avgScore
            FROM DW.USERS U, DW.Competition C, DW.KERNEL K, OP.SUBMISSIONS S, KERNEL_VERSIONS V
            where  U.id = S.userId and C.TeamID = S.teamId and S.SourceKernelVersionId = V.kvId and V.ScriptId = K.id 
            group by U.id , C.id , K.id
        )AA
        LEFT JOIN 
        (
            select COUNT(*) as TotalMessages , SUM(M.Medal) as TotalMedals , MAX(F.id) as Forum , C.id, U.id
            FROM DW.USERS U, DW.Competition C, DW.FORUM F, OP.COMPETITION O, OP.forummessages_TB M
            where C.CompetitionId = O.CompetitionId  AND O.ForumID=F.FORUMID AND F.TopicID=M.forumTID AND M.UserId=U.id
            group by C.id, U.id
        )BB
        ON AA.competition = BB.competition AND AA.user = BB.user
    )
