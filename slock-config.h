/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody";

static const char *colorname[NUMCOLS] = {
	/* NOTE(jordan): colors taken from two-firewatch */
	[INIT] =   "#333333",   /* after initialization */
	[INPUT] =  "#447EBB",   /* during input */
	[FAILED] = "#E05252",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;
