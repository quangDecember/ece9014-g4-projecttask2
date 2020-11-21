
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
      C.CompetitionId  ,
      C.Title   ,
      T.TEAMID   ,
      C.EnabledDate  ,
      C.Deadline   ,
      C.OnlyAllowKernelSubmission  
  from OP.TEAMS T
  LEFT JOIN OP.COMPETITION C
  ON T.COMPETITIONID = C.COMPETITIONID
);
