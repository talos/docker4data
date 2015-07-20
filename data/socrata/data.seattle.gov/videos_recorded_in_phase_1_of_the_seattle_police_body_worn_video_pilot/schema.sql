CREATE TABLE "videos_recorded_in_phase_1_of_the_seattle_police_body_worn_video_pilot" (
	"evidence_id"	text,
	"filename_on_s3"	text,
	"youtube_id"	text,
	"id_external"	text,
	"created_date_record_start"	timestamp,
	"date_record_end"	timestamp,
	"flag_y_n"	text,
	"content_type"	text,
	"size_mb"	real,
	"duration_seconds"	real,
	"owner_first_name"	text,
	"owner_last_name"	text,
	"owner_badge_id"	text,
	"categories"	text,
	"evidence_tags"	text
);
