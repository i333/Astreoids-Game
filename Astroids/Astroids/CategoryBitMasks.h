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

static const uint32_t topCategory = 0x1 << 2;
static const uint32_t bottomCategory = 0x1 << 3;
static const uint32_t leftCategory = 0x1 << 4;
static const uint32_t rightCategory = 0x1 << 5;

// bitwise OR with this category for wrappable object
static const uint32_t wrapCategory = 0x1 << 6;

static const uint32_t asteroidCategory = 0x1 << 7;


#endif /* CategoryBitMasks_h */
