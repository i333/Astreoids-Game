//
//  CategoryBitMasks.h
//  Astroids
//
//  Created by Thomas Donohue on 2/17/16.
//
//

#ifndef CategoryBitMasks_h
#define CategoryBitMasks_h

static const uint32_t shipCategory = 0x1 << 0;
static const uint32_t bulletCategory = 0x1 << 1;

static const uint32_t borderTop = 0x1 << 4;
static const uint32_t borderBottom = 0x1 << 5;
static const uint32_t borderLeft = 0x1 << 6;
static const uint32_t borderRight = 0x1 << 7;

#endif /* CategoryBitMasks_h */
