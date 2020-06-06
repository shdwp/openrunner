//
// Created by shdwp on 3/15/2020.
//

#ifndef GLPL_UTIL_H
#define GLPL_UTIL_H

#include <cstdio>
#include <assert.h>
#include <cstdint>
#include <iostream>

inline int hexdump(void const *data, size_t length, bool ascii = false, int linelen = 16, int split = 8)
{
	char buffer[512];
	char *ptr;
	const uint8_t *inptr;
	int pos;
	int remaining = length;

	inptr = (const uint8_t *)data;

	/*
	 *	Assert that the buffer is large enough. This should pretty much
	 *	always be the case...
	 *
	 *	hex/ascii gap (2 chars) + closing \0 (1 char)
	 *	split = 4 chars (2 each for hex/ascii) * number of splits
	 *
	 *	(hex = 3 chars, ascii = 1 char) * linelen number of chars
	 */
	assert(sizeof(buffer) >= (3 + (4 * (linelen / split)) + (linelen * 4)));

	/*
	 *	Loop through each line remaining
	 */
	while (remaining > 0) {
		int lrem;
		int splitcount;
		ptr = buffer;

		/*
		 *	Loop through the hex chars of this line
		 */
		lrem = remaining;
		splitcount = 0;
		for (pos = 0; pos < linelen; pos++) {

			/* Split hex section if required */
			if (split == splitcount++) {
				sprintf(ptr, "  ");
				ptr += 2;
				splitcount = 1;
			}

			/* If still remaining chars, output, else leave a space */
			if (lrem) {
				sprintf(ptr, "%0.2x ", *((unsigned char *) inptr + pos));
				lrem--;
			} else {
				sprintf(ptr, "   ");
			}
			ptr += 3;
		}

		*ptr++ = ' ';
		*ptr++ = ' ';

        if (ascii) {
            lrem = remaining;
            splitcount = 0;
            for (pos = 0; pos < linelen; pos++) {
                unsigned char c;

                /* Split ASCII section if required */
                if (split == splitcount++) {
                    sprintf(ptr, "  ");
                    ptr += 2;
                    splitcount = 1;
                }

                if (lrem) {
                    c = *((unsigned char *) inptr + pos);
                    if (c > 31 && c < 127) {
                        sprintf(ptr, "%c", c);
                    } else {
                        sprintf(ptr, ".");
                    }
                    lrem--;
                    /*
                     *	These two lines would pad out the last line with spaces
                     *	which seems a bit pointless generally.
                     */
                    /*
                        } else {
                            sprintf(ptr, " ");
                    */

                }
                ptr++;
            }
        }

		*ptr = '\0';
		//fprintf(fd, "%s\n", buffer);
		std::cout << buffer << std::endl;

		inptr += linelen;
		remaining -= linelen;
	}

	return 0;
}

#endif //GLPL_UTIL_H
