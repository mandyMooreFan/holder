insert into player_card
  select *
  from (
         select
           uuid(),
           'Brian Dozier',
           'MIN',
           '2018',
           '12',
           'FIELDER',
           'RIGHT',
           '545',
           '0' as test,
           '20',
           '4',
           'SECOND_BASE',
           '1' as oldddd,
           '1',
           '2',
           '3',
           '4' as holy,
           '5',
           '6',
           '9',
           '10',
           '16',
           '17',
           '18',
           '0' as ittttn,
           '0' as no_way,
           '19',
           '100'
       ) as fake_table;