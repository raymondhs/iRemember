//
//  IRHeader.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define LANG_CHINESE @"Chinese"
#define LANG_ENGLISH @"English"
#define LANG_INDONESIAN @"Indonesian"
#define DEFAULT_LANGUAGE LANG_CHINESE
#define DEFAULT_STUDYPLAN @"iRemember Study Plan"
#define DEFAULT_TOTAL_DAYS 10
#define DEFAULT_HOUR 9
#define DEFAULT_MINUTE 0
#define MAX_SEARCH_SIZE 1000000
#define NUMBER_REVIEW 6

#define GAME_MCQ @"Multiple Choice Quiz"
#define GAME_HANGMAN @"Hangman"
#define GAME_LISTENING @"Listening Test"

#define GAME_FRAME_WIDTH 1024
#define GAME_FRAME_HEIGHT 660
#define GAME_TOOLBAR_WIDTH 100
#define GAME_TOOLBAR_HEIGHT 30
#define GAME_TABLEVIEW_ORIGIN_X 250
#define GAME_TABLEVIEW_ORIGIN_Y 100
#define GAME_CELL_HEIGHT1 100
#define GAME_CELL_HEIGHT2 44
#define GAME_TABLEVIEW_WIDTH 500
#define GAME_TABLEVIEW_HEIGHT 500
#define GAME_LABEL_FONT 36.0
#define GAME_MCQ_LABEL_WIDTH 438
#define GAME_MCQ_LABEL_HEIGHT 100
#define GAME_TABLEVIEW_CELLICON_LENGTH 40
#define GAME_LISTENING_ICON_OX 185
#define GAME_LISTENING_ICON_OY 20
#define GAME_LISTENING_ICON_W 60
#define GAME_LISTENING_ICON_H 50
#define GAME_ANIMATION_DURATION 0.8
#define GAME_ANIMATION_DELAY 0.1

#define STATISTICS_BAR_HEIGHT 500
#define STATISTICS_BAR_WIDTH 60
#define STATISTICS_BARS_INTERVAL 20
#define STATISTICS_BAR_OFFSET_X 100
#define STATISTICS_BAR_OFFSET_Y 550
#define STATISTICS_XAXIS_LENGTH 530
#define STATISTICS_AXIS_WIDTH 4
#define STATISTICS_YXIS_HEIGHT 460

#define SPSETTING_REVIEWGAME @"Review Game"
#define SPSETTING_NUMWORDS @"Number of words in each review"
#define SPSETTING_ORDERING @"Ordering"
#define SPSETTING_REVIEWINTERVAL @"Review Interval"

#define SPORDERING_ALPHABETICAL @"Alphabetical"
#define SPORDERING_REVERSED @"Reversed"
#define SPORDERING_RANDOM @"Random"

#define SPMODE_EBENHAUSE @"Ebenhause"
#define SPMODE_DAILY @"Daily"

#define RECORDING_TIME 3

#define BACKGROUND_IMAGE_FILE @"bg-wood2.jpg"

typedef enum {
	IRGameStartAll = 0,
	IRGameStartStudied = 1,
	IRGameStartDifficult = 2,
	IRGameStartNext = 3
} IRGameStartMode;