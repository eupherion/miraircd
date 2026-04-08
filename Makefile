COMMON_CXXFLAGS = -Wall -Werror -Wextra -std=c++98 -I $(INCLUDEFOLDER) -I ./$(LIBJSONFOLDER)/src

NAME= ircserv

SOURCEFILES=    main.cpp \
               Server.cpp \
               User.cpp \
               Message.cpp \
               utils.cpp \
               sendError.cpp \
               sendReply.cpp \
               Channel.cpp \
               History.cpp \
               Hash.cpp \
               commands/channelCommands.cpp \
               commands/otherCommands.cpp \
               commands/registrationCommands.cpp \
               commands/userCommands.cpp \
               commands/ircOperatorCommands.cpp

LIBJSONFOLDER = json-parser
LIBJSONFLAGS = -ljson -L ./$(LIBJSONFOLDER) -I ./$(LIBJSONFOLDER)/src

BOTFOLDER = bot/

SOURCEFOLDER= srcs/
OSOURCEFOLDER= objects/
INCLUDEFOLDER= include/

SOURCE= $(addprefix $(SOURCEFOLDER), $(SOURCEFILES))
OSOURCE= $(addprefix $(OSOURCEFOLDER), $(SOURCEFILES:.cpp=.o))

all: libjson bot $(NAME)

$(OSOURCEFOLDER):
	mkdir objects
	mkdir objects/commands

$(OSOURCEFOLDER)%.o: $(SOURCEFOLDER)%.cpp
	clang++ $(COMMON_CXXFLAGS) -c $< -o $@

libjson:
	@if ! [ "$(shell ls -A $(LIBJSONFOLDER) 2>/dev/null)" ] ; then git submodule update --init; fi
	$(MAKE) -C $(LIBJSONFOLDER) all

bot:
	$(MAKE) -C $(BOTFOLDER) all

$(NAME): $(OSOURCEFOLDER) $(OSOURCE)
	clang++ $(OSOURCE) -o $(NAME) $(LIBJSONFLAGS)

clean:
	$(MAKE) -C $(LIBJSONFOLDER) clean
	$(MAKE) -C $(BOTFOLDER) clean
	rm -rf $(OSOURCEFOLDER)

fclean: clean
	$(MAKE) -C $(LIBJSONFOLDER) fclean
	$(MAKE) -C $(BOTFOLDER) fclean
	rm -rf $(NAME)

re: fclean all

.PHONY: clean fclean re all bot libjson