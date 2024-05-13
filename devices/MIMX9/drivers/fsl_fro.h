/*
 * Copyright 2024 NXP
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * o Redistributions of source code must retain the above copyright notice, this list
 *   of conditions and the following disclaimer.
 *
 * o Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 *
 * o Neither the name of the copyright holder nor the names of its
 *   contributors may be used to endorse or promote products derived from this
 *   software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*==========================================================================*/
/*!
 * @addtogroup MX9_FRO_driver
 * @{
 *
 * @file
 * @brief
 *
 * Header file containing the API for the FRO (Free-Running Oscillator) driver.
 */
/*==========================================================================*/

#ifndef FSL_FRO_H
#define FSL_FRO_H

/* Includes */

#include "fsl_common.h"

/* Defines */

/* Types */

/*!
 * @brief FRO operation mode.
 */
typedef enum
{
    OPEN_LOOP    = 1U, /*!< Open loop mode. */
    CLOSED_LOOP  = 2U  /*!< Close loop mode. */
} FRO_mode;

/*!
 * FRO configuration info
 */
typedef struct {
    uint32_t outputFreq; /*!< FRO output frequency. */
    FRO_mode mode;       /*!< FRO operation mode. */
    uint32_t trimVal;    /*!< FRO trim value. */
} FRO_config_info_t;

/* Functions */

/*!
 * @name FRACTPLL driver functions
 * @{
 */

/*!
 * Set FRO default configuration
 *
 * @param[in]   defConfig     FRO default configuration
 *
 * This function allows caller to set FRO default configuration.
 *
 * @return Returns true if FRO default configuration is configured
 *         successfully.
 */
bool FRO_SetDefaultConfig(const FRO_config_info_t defConfig);

/*!
 * Get FRO default configuration
 *
 * @param[out]   config     FRO configuration
 *
 * This function allows caller to get FRO default configuration.
 *
 * @return Returns true if FRO default configuration is retrieved successfully.
 */
bool FRO_GetDefaultConfig(FRO_config_info_t *config);

/*!
 *  Set FRO operation mode
 *
 * @param[in]   mode     FRO operation mode
 *
 * This function allows caller to set FRO opetation mode (open/close loop)
 *
 * @return Returns true if FRO operation mode is configured successfully.
 */
bool FRO_SetMode(FRO_mode mode);

/*!
 *  Get FRO operation mode
 *
 * @param[out]   mode     FRO operation mode
 *
 * This function allows caller to get FRO opetation mode (open/close loop)
 *
 * @return Returns true if FRO operation mode is retrieved successfully.
 */
bool FRO_GetMode(FRO_mode *mode);

/*!
 *  Set FRO trim value
 *
 * @param[in]   trim     FRO trim value
 *
 * @return Returns true if FRO trim value is configured successfully.
 */
bool FRO_SetTrim(uint32_t trim);

/*!
 *  Get FRO trim value
 *
 * @param[out]   trim     FRO trim value
 *
 * @return Returns true if FRO trim value is retrieved successfully.
 */
bool FRO_GetTrim(uint32_t *trim);

/*!
 * Set FRO output frequency rate
 *
 * @param[in]   rate     FRO output frequency rate
 *
 * @return Returns true if FRO output frequency is configured successfully.
 */
bool FRO_SetRate(uint32_t rate);

/*!
 * Get FRO output frequency rate
 *
 * @param[out]   rate     FRO output frequency rate
 *
 * @return Returns true if FRO output frequency rate is retrieved successfully.
 */
bool FRO_GetRate(uint32_t *rate);

/*!
 * Set (enable/disable) FRO
 *
 * @param[in]   enable     Enable flag (1=enabled, 0=disabled)
 *
 * This function allows caller to configure and set (enable/disable) FRO.
 *
 * @return Returns true if FRO configuration is updated successfully.
 */
bool FRO_SetEnable(bool enable);

/*!
 * Get FRO enable status
 *
 * @return Returns true if FRO is enabled.
 */
bool FRO_GetEnable(void);

/** @} */

#endif /* FSL_FRO_H */

/** @} */
