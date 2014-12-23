#ifndef RUNLENGTH_H
#define RUNLENGTH_H

#include <stdio.h>
#include <stdlib.h>

#include "darray.h"
#include "definitions.h"
#include "parsers.h"

/*! \defgroup rle Run length encoding */
/*!@{*/
#define     END_RLE_TOKEN '!'
#define    DEAD_RLE_TOKEN 'b'
#define   ALIVE_RLE_TOKEN 'o'
#define NEWLINE_RLE_TOKEN '$'

//! Polymorphism!
/*! A union for RleToken */
union Tokenizable
{
  char char_;
  int int_;
  void *ptr_;
};

struct RleToken
{
  union Tokenizable value;
  int repeat;
};

struct TokenParser
{
  FILE *file;
  char *buff;
  int   i;
};

struct TokenWriter
{
  FILE *file;
  int   line_length;
};

//! Game of Life .rle file contents
struct LifeRle
{
  struct RleToken *tokens; //!< An array of `char` tokens
  /*!< The tokens have one of the following values:

     END_RLE_TOKEN
     DEAD_RLE_TOKEN
     ALIVE_RLE_TOKEN
     NEWLINE_RLE_TOKEN
      
    The token `END_RLE_TOKEN` indicates the end of the array. */
  int x;
  int y;
  rule r;
};

struct TokenParser tp_new(FILE *file);
int tp_regenerate(struct TokenParser *tp);
struct RleToken life_rle_token(struct TokenParser *tp);

void write_tokens(struct TokenWriter *, struct RleToken *);
void write_one_token(struct TokenWriter *, struct RleToken);

struct LifeRle LifeRle_read(FILE *file);
void           LifeRle_write(FILE *file, struct LifeRle rle);
/*@}*/
#endif