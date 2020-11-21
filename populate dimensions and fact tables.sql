
INSERT INTO DW.COMPETION_DIM (
    COMPETITION_ID,
    COMPETITION_TITLE,
    TEAM_ID,
    ENABLEDDATE,
    DEADLINE,
    ONLYALLOWKERNELSUBMISSION
) 
(
  select 
      C.CompetitionId AS Competition_Id  ,
      C.Title AS Competition_Title  ,
      T.TEAMID AS Team_Id ,
      C.EnabledDate EnabledDate ,
      C.Deadline AS Deadline ,
      C.OnlyAllowKernelSubmission AS OnlyAllowKernelSubmission 
  from KAGGLE_META.TEAMS T
  LEFT JOIN KAGGLE_META.COMPETITION C
  ON T.COMPETITIONID = C.COMPETITIONID
);
