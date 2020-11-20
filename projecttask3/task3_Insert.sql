INSERT INTO DW.Competition(Title, TeamID, EnabledDate, DeadlineDate, OnlyAllowKernelSubmissions, TeamLeader)
    (
        SELECT c.Title, t.teamID, c.EnabledDate, c.DeadlineDate, c.OnlyAllowKernelSubmissions, t.TeamLeader
        FROM op.COMPETITION c, op.TEAMS t
        WHERE
            c.CompetitionId = t.CompetitionId
    )

INSERT INTO DW.Dataset(Title, Subtitle, OwnerUserId, CurrentDatasetVersionId)
    (
        SELECT Title, Subtitle, OwnerUserId, CurrentDatasetVersionId
        FROM op.datasets_TB
    )

INSERT INTO DW.USER(UserName, DisplayName, RegisterDate, PerformanceTier)
    (
        SELECT UserName, DisplayName, RegisterDate, PerformanceTier
        FROM op.USERS
    )

INSERT INTO DW.FORUM(Title, Creationdate, TopicID)
    (
        SELECT f.Title, ft.Creationdate, ft.Forumtid
        FROM op.forum_TB f, op.forumtopics_TB ft
        WHERE
            f.ForumID = ft.forumid
    )

INSERT INTO DW.KERNEL(CreationDate, AuthorUserID, CurrentKernelVersionID, MadePublicDate)
    (
        SELECT CreationDate, AuthorId, CurrentKernelVersionId, MadePublicDate
        FROM op.KERNELS
    )