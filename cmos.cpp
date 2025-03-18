#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

struct programSimilarity{
    string cFile1;
    string cFile2;
    float similarityScore;
};

struct cFile{
    pair<string, string> fileToToken;
    vector<size_t> hashedFingerprints;
};

int main (){
    const int FINGERPRINT_WIDTH = 4;
    ifstream file;
    vector<cFile> programs;
    string programName = "";
    string tokenizedProgram = "";

    file.open("./tokens.txt");

    if (!file)
    {
        std::cerr << "Unable to open file datafile.txt";
        exit(1);
    }

    while (!file.eof()){
        file >> programName;
        file >> tokenizedProgram;
        cFile *program = new cFile();
        program->fileToToken = make_pair(programName, tokenizedProgram);
        programs.push_back(*program);
    }

    file.close();

    for (size_t i = 0; i < programs.size(); i++){
        vector<string> kmers;
        cout << "program " << i << endl;
        for (size_t j = 0; j < programs[i].fileToToken.second.size() - FINGERPRINT_WIDTH; j++){
            string kmer = programs[i].fileToToken.second.substr(j, FINGERPRINT_WIDTH);
            kmers.push_back(kmer);
            cout << "kmer: " << kmer << endl;
        }
    }

    return 0;
}