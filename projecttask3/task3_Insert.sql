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

INSERT INTO DW.PERFORMANCE_FACT(UsersID, CompetitionsID, DatasetsID, ForumsID, KernelsID, TotalSubmissions, TotalMedals, TotalForumMessages)
    (
        SELECT dw_u.ID, dw_c.ID, dw_d.ID, dw_f.ID, dw_k.ID, COUNT(s.submissionId), SUM(a.TotalGold)+SUM(a.TotalSilver)+SUM(a.TotalBronze), COUNT(fm.ForumMID)
        FROM DW.COMPETITION dw_c, DW.DATASET dw_d, DW.USER dw_u, DW.FORUM dw_f, DW.KERNEL dw_k, op.SUBMISSIONS s, op.USER_ACHIEVEMENTS a, op.forummessages_TB fm
        WHERE
            dw_u.UserId = s.userId
        and dw_u.UserId = fm.UserId
        and dw.u.UserId = a.userId
        GROUP BY
            dw.u.UserId
    )