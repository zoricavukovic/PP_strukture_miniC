%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"
  #include "codegen.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

  extern int yylineno;
  int out_lin = 0;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
  int lab_num = -1;
  FILE *output;
  
  int struct_idx = -1;
  struct_atribute* attribute_map[128];
  char* attr_array[200];
  
  
%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token _POINT
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token _STRUCT
%token <i> _AROP
%token <i> _RELOP

%type <i> num_exp exp literal new_ID
%type <i> function_call argument rel_exp if_part

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : struct_list global_struct_list function_list
      {  
        
        if(lookup_symbol("main", FUN) == NO_INDEX)
          err("undefined reference to 'main'");
        print_symtab();
      }
      
  ;

struct_list
  : 
  | struct_list struct_id _LBRACKET attribute_list _RBRACKET _SEMICOLON
  ;
  
struct_id
  : _STRUCT _ID 
  	{
        if (lookup_symbol($2, STRUCT) != NO_INDEX)
           err("already defined struct with same name '%s'", $2);
        else{
           struct_idx = insert_symbol($2, STRUCT, NO_ATR, NO_ATR, NO_ATR);
           struct_atribute* param_types = (struct_atribute*) malloc(sizeof(struct_atribute)*128);
           attribute_map[struct_idx] = param_types;
           //code("\n@%s: WORD 0", $2);
        }
     }
  ;

attribute_list
  :
    {
  	set_atr1(struct_idx, 0);
    }
  | attribute_list struct_attribute
  ;
  
struct_attribute
  : _TYPE _ID _SEMICOLON
      {
         int found = 0;
         int i = 0;
         int num_attribute = get_atr1(struct_idx);
         for (i; i < num_attribute; i++){
            if (strcmp(attr_array[i], $2) == 0){
            	found = 1;
               err("already declared attribute in same struct with same name '%s'", $2);
               break;
            }
         }
         if (found == 0){
            attr_array[num_attribute] = $2;
            //postavljamo kao name atribut za atribute strukture ime_strukture.naziv_atributa
            
            char* name_with_extension;
            const char* name = get_name(struct_idx);
		name_with_extension = malloc(strlen(name)+1+50); /* make space for the new string (should check the return value ...) */
		strcpy(name_with_extension, name); /* copy name into the new var */
		strcat(name_with_extension, "."); /* add the extension */
		strcat(name_with_extension, $2);
		
		
	    struct_atribute* param_types = attribute_map[struct_idx];
	    struct_atribute new_attr;
	    new_attr.type = $1;
	    strcpy(new_attr.ime, $2);
	    param_types[num_attribute] = new_attr;
	    num_attribute += 1;
	    set_atr1(struct_idx, num_attribute);
	    //code("\n%s:\n\t\tWORD\t1", $2);
	    //code("\n\t%s:\n\t\tWORD\t1", $2);
         }
      }
  ;

global_struct_list
  : 
  | global_struct global_struct_list
  ;
  
global_struct
	:_STRUCT _ID _ID _SEMICOLON {
		int idx_struct_for_variable = lookup_symbol($2, STRUCT);
        if(idx_struct_for_variable == NO_INDEX)
           err("'%s' undeclared structure name", $2);		//atr3
        else{
           if(lookup_symbol($3, STRUCT_VAR) == NO_INDEX){
              int idx = insert_symbol($3, STRUCT_VAR, 0, idx_struct_for_variable, NO_ATR);
              struct_atribute *lista_atr = attribute_map[idx_struct_for_variable];
              int num_atr = get_atr1(idx_struct_for_variable);
              int i = 0;
              //code("\n@%s: WORD 0", $3);
              
              	struct_atribute atr1;
              for(; i < num_atr; i++){
                
                struct_atribute atr2 = lista_atr[i];
                char* name_with_extension;
            	const char* name = get_name(struct_idx);
				name_with_extension = malloc(strlen(name)+1+50); /* make space for the new string (should check the return value ...) */
				strcpy(name_with_extension, $3); /* copy name into the new var */
				strcat(name_with_extension, "_"); /* add the extension */
				strcat(name_with_extension, atr2.ime);
                code("\n%s:\n\t\tWORD\t12", name_with_extension);
              	atr1 =  lista_atr[i];
              	char *imeTmp = malloc(50);
              	strcpy(imeTmp, lista_atr[i].ime);
              	insert_symbol(name_with_extension, STRUCT_ATR, (lista_atr[i]).type, idx, NO_ATR);
              	//printf("%s", atr1.ime);	
              
              }
              
           }
           else 
              err("redefinition of '%s'", $3);
        }
	}
	//| _STRUCT _ID _ID _ASSIGN _LBRACKET _RBRACKET _SEMICOLON
	;

  

function_list
  : function
  | function_list function
  ;

function
  : _TYPE _ID
      {
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == NO_INDEX)
          fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
        else 
          err("redefinition of function '%s'", $2);

        code("\n%s:", $2);
        code("\n\t\tPUSH\t%%14");
        code("\n\t\tMOV \t%%15,%%14");
      }
    _LPAREN parameter _RPAREN body
      {
        clear_symbols(fun_idx + 1);
        var_num = 0;
        
        code("\n@%s_exit:", $2);
        code("\n\t\tMOV \t%%14,%%15");
        code("\n\t\tPOP \t%%14");
        code("\n\t\tRET");
      }
  ;

parameter
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | _TYPE _ID
      {
        insert_symbol($2, PAR, $1, 1, NO_ATR);
        set_atr1(fun_idx, 1);
        set_atr2(fun_idx, $1);
      }
  ;

body
  : _LBRACKET variable_list
      {
        if(var_num)
          code("\n\t\tSUBS\t%%15,$%d,%%15", 4*var_num);
        code("\n@%s_body:", get_name(fun_idx));
      }
    statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

variable
  : _TYPE _ID _SEMICOLON
      {
        if(lookup_symbol($2, VAR|PAR) == NO_INDEX)
           insert_symbol($2, VAR, $1, ++var_num, NO_ATR);
        else 
           err("redefinition of '%s'", $2);
      }
  ;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | if_statement
  | return_statement
  ;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, VAR|PAR);
        if(idx == NO_INDEX)
          err("invalid lvalue '%s' in assignment", $1);
        else
          if(get_type(idx) != get_type($3))
            err("incompatible types in assignment");
        gen_mov($3, idx);
      }
  | new_ID _ASSIGN num_exp _SEMICOLON
      {
          if ($1 != -1){
	      	if(get_type($1) != get_type($3))
				err("incompatible types in assignment");
			
	    	gen_mov($3, $1);
        }
      }
  
  ;
  

num_exp
  : exp

  | num_exp _AROP exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: arithmetic operation");
        int t1 = get_type($1);    
        code("\n\t\t%s\t", ar_instructions[$2 + (t1 - 1) * AROP_NUMBER]);
        gen_sym_name($1);
        code(",");
        gen_sym_name($3);
        code(",");
        free_if_reg($3);
        free_if_reg($1);
        $$ = take_reg();
        gen_sym_name($$);
        set_type($$, t1);
      }
  ;

exp
  : literal

  | _ID
      {
        $$ = lookup_symbol($1, VAR|PAR);
        if($$ == NO_INDEX)
          err("'%s' undeclared", $1);
      }

  | function_call
      {
        $$ = take_reg();
        gen_mov(FUN_REG, $$);
      }
  
  | _LPAREN num_exp _RPAREN
      { $$ = $2; }
  | new_ID
      { $$ = $1; }
  ;
  
new_ID
  : _ID _POINT _ID
  {
    //proveriti dal prvi id pripada ijednoj inicijalizovanoj strukturi
    int idx_struct_var = lookup_symbol($1, STRUCT_VAR);
    if (idx_struct_var == NO_INDEX){
		err("undefined struct var '%s'", $1);
		
	}
	else{
		//dal drugi id pripada tim atributima
		int idx_struct = get_atr1(idx_struct_var);
		struct_atribute *lista_atr = attribute_map[idx_struct];
		int num_atr = get_atr1(idx_struct);
		int i = 0;
		int found = 0;
		for(; i < num_atr; i++){
			struct_atribute atr = lista_atr[i];
			if (strcmp(atr.ime, $3) == 0){
		   		found = 1;
		   		break;
			}
		}
		if (found == 0){
		   err("undefined struct attr '%s'", $3);
		
		}
		else{
			// i kao povrtanu vrednost pojma indx u tabeli da bi mogao da dohvati tip tog atributa(to je drugi id)
				//look_up(ime, index_variable) 
				char* name_with_extension;
            	const char* name = $1;
				name_with_extension = malloc(strlen(name)+1+50); /* make space for the new string (should check the return value ...) */
				strcpy(name_with_extension, name); /* copy name into the new var */
				strcat(name_with_extension, "_"); /* add the extension */
				strcat(name_with_extension, $3);
				printf("%s", name_with_extension);
				$$ = lookup_symbol_struct(name_with_extension, STRUCT_ATR, idx_struct_var);
		}
	}
	
	
}

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;

function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("'%s' is not a function", $1);
      }
    _LPAREN argument _RPAREN
      {
        if(get_atr1(fcall_idx) != $4)
          err("wrong number of arguments");
        code("\n\t\t\tCALL\t%s", get_name(fcall_idx));
        if($4 > 0)
          code("\n\t\t\tADDS\t%%15,$%d,%%15", $4 * 4);
        set_type(FUN_REG, get_type(fcall_idx));
        $$ = FUN_REG;
      }
  ;

argument
  : /* empty */
    { $$ = 0; }

  | num_exp
    { 
      if(get_atr2(fcall_idx) != get_type($1))
        err("incompatible type for argument");
      free_if_reg($1);
      code("\n\t\t\tPUSH\t");
      gen_sym_name($1);
      $$ = 1;
    }
  ;

if_statement
  : if_part %prec ONLY_IF
      { code("\n@exit%d:", $1); }

  | if_part _ELSE statement
      { code("\n@exit%d:", $1); }
  ;

if_part
  : _IF _LPAREN
      {
        $<i>$ = ++lab_num;
        code("\n@if%d:", lab_num);
      }
    rel_exp
      {
        code("\n\t\t%s\t@false%d", opp_jumps[$4], $<i>3);
        code("\n@true%d:", $<i>3);
      }
    _RPAREN statement
      {
        code("\n\t\tJMP \t@exit%d", $<i>3);
        code("\n@false%d:", $<i>3);
        $$ = $<i>3;
      }
  ;

rel_exp
  : num_exp _RELOP num_exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: relational operator");
        $$ = $2 + ((get_type($1) - 1) * RELOP_NUMBER);
        gen_cmp($1, $3);
      }
  ;

return_statement
  : _RETURN num_exp _SEMICOLON
      {
        if(get_type(fun_idx) != get_type($2))
          err("incompatible types in return");
        gen_mov($2, FUN_REG);
        code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));        
      }
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();
  output = fopen("output.asm", "w+");

  synerr = yyparse();

  clear_symtab();
  fclose(output);
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count) {
    remove("output.asm");
    printf("\n%d error(s).\n", error_count);
  }

  if(synerr)
    return -1;  //syntax error
  else if(error_count)
    return error_count & 127; //semantic errors
  else if(warning_count)
    return (warning_count & 127) + 127; //warnings
  else
    return 0; //OK
}

