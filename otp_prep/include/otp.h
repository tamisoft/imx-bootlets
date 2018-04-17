/*
 * Levente Tamas <tamisoft@gmail.com>
 *
 * Copyright 2009-2010 Freescale Semiconductor, Inc. All Rights Reserved.
 *
 * This file is licensed under the terms of the GNU General Public License
 * version 2.  This program  is licensed "as is" without any warranty of any
 * kind, whether express or implied.
 *
 * http://www.opensource.org/licenses/gpl-license.html
 * http://www.gnu.org/copyleft/gpl.html
 */


#ifndef __OTP_H__
#define __OTP_H__

int otp_write(int address, int data);
int otp_open_read();
int otp_close_read();


#endif //__OTP_H__
