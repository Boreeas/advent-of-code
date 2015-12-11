#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define SIZE 1000

void setlight(int * lights, int x, int y, int val)
{
	if (val) 
	{
		lights[x * SIZE + y] += 1;
	}
	else if (lights[x * SIZE + y] > 0)
	{
		lights[x * SIZE + y] -= 1;
	}
}

void togglelight(int * lights, int x, int y) 
{
	lights[x * SIZE + y] += 2;
}

int getlight(int * lights, int x, int y)
{
	return lights[x * SIZE + y];
}

int count_lights(int * lights) {
	int acc;
	acc = 0;
	for (int x = 0; x < SIZE; x++) {
		for (int y = 0; y < SIZE; y++) {
			acc += getlight(lights, x, y);
		}
	}

	return acc;
}

void get_range(FILE *fp, int *sx, int *sy, int *ex, int *ey)
{
	char garbage[16];
	fscanf(fp, "%d,%d through %d,%d", sx, sy, ex, ey);
}


void set_all_lights(int * lights, int sx, int sy, int ex, int ey, int on) {
	for (int x = sx; x <= ex; x++) {
		for (int y = sy; y <= ey; y++) {
			setlight(lights, x, y, on);
		}
	}
}

void toggle_all_lights(int * lights, int sx, int sy, int ex, int ey) {
	for (int x = sx; x <= ex; x++) {
		for (int y = sy; y <= ey; y++) {
			togglelight(lights, x, y);
		}
	}
}


int main(void) 
{
	FILE* fp;
	char buf[256];
	int* lights;

	lights = (int*) calloc(SIZE*SIZE, sizeof(int));
	fp = fopen("input.txt", "r");

	while (fscanf(fp, "%s", buf) && !feof(fp)) {
		if (!strcmp(buf, "toggle")) {
			int sx, sy, ex, ey;
			get_range(fp, &sx, &sy, &ex, &ey);
			toggle_all_lights(lights, sx, sy, ex, ey);
		} else if (!strcmp(buf, "turn")) {
			fscanf(fp, "%s", buf);
			int on = strcmp(buf, "off");
			int sx, sy, ex, ey;
			get_range(fp, &sx, &sy, &ex, &ey);
			set_all_lights(lights, sx, sy, ex, ey, on);
		} else {
			printf("Unknown action '%s'\n", buf);
			return 1;
		}
	}

	printf("Lights turned on: %d\n", count_lights(lights));
}
