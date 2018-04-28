create table player_card (
  uuid            CHAR(36)    NOT NULL,
  name            VARCHAR(50) NOT NULL,
  team            VARCHAR(50) NOT NULL,
  season          Enum(
                  '2000',
                  '2001',
                  '2018'
                  ),
  pitch_modifier  INT         not null,
  player_type     ENUM(
                  'PITCHER',
                  'FIELDER'),
  hand            ENUM(
                  'LEFT',
                  'RIGHT'),
  salary          int         not null,
  innings_pitched int,
  speed           int,
  defense         int,
  position        enum(
                  'FIRST_BASE',
                  'SECOND_BASE',
                  'THIRD_BASE',
                  'SHORT_STOP',
                  'CATCHER',
                  'PITCHER',
                  'LEFT_FIELD',
                  'CENTER_FIELD',
                  'RIGHT_FIELD',
                  'DH',
                  'RELIEF_PITCHER',
                  'CLOSER'
                  ),
  out_so_lower    int,
  out_so_upper    int,
  out_gb_lower    int,
  out_gb_upper    int,
  out_fb_lower    int,
  out_fb_upper    int,
  walk_lower      int,
  walk_upper      int,
  single_lower    int,
  single_upper    int,
  double_lower    int,
  double_upper    int,
  triple_lower    int,
  triple_upper    int,
  homer_lower     int,
  homer_upper     int,

  PRIMARY KEY (uuid)
);