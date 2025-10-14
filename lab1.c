 #include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct student
{
        char SID[20];
        char name[30];
        char branch[25];
        char semester[10];
        char address[25];
}stu;

stu st;

void insert_new()
{
        printf("Enter SID: ");
        scanf("%s", st.SID);
        printf("Enter name: ");
        scanf("%s", st.name);
        printf("Enter branch: ");
        scanf("%s", st.branch);
        printf("Enter semester: ");
        scanf("%s", st.semester);
        printf("Enter address: ");

        getchar();
        fgets(st.address, sizeof(st.address), stdin);

        st.address[strcmp(st.address, "\n")]= '\0';

        FILE *fp;
        fp= fopen("student_info.txt", "a");

        if(fp==NULL)
        {
                printf("Error can't open the file now!!\n");
                return;
        }

        fprintf(fp, "%s\t%s\t%s\t%s\t%s\n", st.SID, st.name, st.branch, st.semester, st.address);
        fclose(fp);
        printf("The student data has been added to the file\n");
}

void modify_add()
{
        char new_id[20];
        int flag=0;
        printf("Enter the student ID whose address needs to be modified: ");
        scanf("%s", new_id);
        FILE *fp= fopen("student_info.txt", "r");
        if(fp==NULL)
        {
                printf("Error opening the file!!\n");
                return;
        }

        FILE *fp1= fopen("sample.txt", "a");
        if(fp1==NULL)
        {
                printf("Error open the file!!\n");
                return;
        }

        while(fscanf(fp, "%s %s %s %s %s", st.SID, st.name, st.branch, st.semester, st.address)!=EOF)
        {
                if(strcmp(st.SID, new_id)==0)
                {
                        printf("Enter the new address of the student: ");
                        scanf("%s", st.address);
                        flag=1;
                }

                fprintf(fp1, "%s\t%s\t%s\t%s\t%s\n", st.SID, st.name, st.branch, st.semester, st.address);
        }

        if(flag)
                printf("The address is successfully modified\n");
        else
                printf("The student with the given student ID does not exist\n");
        fclose(fp);
        fclose(fp1);

        remove("student_info.txt");
        rename("sample.txt", "student_info.txt");
}

void delete_st()
        {
                char new_ID[20];
                int flag=0;
                printf("Enter the student ID whose enetry in the file is to be deleted\n");
                scanf("%s",new_ID);
                FILE *fp=fopen("student_info.txt","r");
                if(fp==NULL)
                {
                        printf("Error opening the file1\n");
                        return;
                }
                FILE *fp1=fopen("sample.txt","a");
                if(fp1==NULL)
                {
                        printf("Error opening the file!\n");
                        return;
                  }
                while(fscanf(fp,"%s %s %s %s %s ",st.SID,st.name,st.branch,st.semester,st.address)!=EOF)
                {
                        if(strcmp(st.SID,new_ID)!=0)
                        {
                                fprintf(fp1,"%s\t %s\t %s\t %s\t %s\n",st.SID,st.name,st.branch,st.semester,st.address);
                        }
                        else
                        {
                                flag=1;
                        }
                }
                if(flag)
                {
                        printf("The student with the given ID is deleted successfully\n");
                }
                fclose(fp);
                fclose(fp1);
                remove("student_info.txt");
                rename("sample.txt","student_info.txt");
        }


void list_cse()
{
        int flag=0;
        FILE *fp = fopen("student_info.txt","r");

        if(fp==NULL)
        {
                printf("Error opening the file!!\n");
                return;
        }

        printf("The list of all students of cse branch\n");

        while(fscanf(fp,"%s%s%s%s%s",st.SID,st.name,st.branch,st.semester,st.address)!=EOF)
        {
                if(strcmp(st.branch,"CSE")==0)
                {
                        printf("Student ID: %s\n",st.SID);
                        printf("Student name: %s\n",st.name);
                        printf("Student branch: %s\n",st.branch);
                        printf("Student semester: %s\n",st.semester);
                        printf("Student address: %s\n",st.address);
                        printf("---------------------------------------\n");
        flag=1;
                }
        }
        if(flag==0)
                printf("There is no student present in CSE in the file\n");
        fclose(fp);
}


void list_cse_kuv()
{
        int flag=0;

        FILE *fp= fopen("student_info.txt", "r");

        if(fp==NULL)
        {

                printf("Error opening the file\n");
                return;
        }

        printf("\n-------CSE students in Kuvempunagar----------\n");

        while(fscanf(fp, "%s %s %s %s %s", st.SID, st.name, st.branch, st.semester, st.address)!=EOF)
        {
                if(strcmp(st.branch, "CSE")==0 && strcmp(st.address, "kuvempunagar")==0)
                {
                        printf("Student SID: %s\n", st.SID);
                        printf("Student name: %s\n", st.name);
                        printf("Student branch: %s\n", st.branch);
                        printf("Student semester: %s\n", st.semester);
                        printf("Student address: %s\n", st.address);
                        printf("---------------------------\n");
                        flag=1;
                }
        }

        if(flag==0)
                printf("There is no student whose branch is CSE and reside in  Kuvempunagar");
        fclose(fp);
}

int main()
{
        int ch;
        while(1)
        {
                printf("\nMENU\n");
                printf("1.Insert a new student\n");
                printf("2.Modify the address of a student based on SID \n");
                printf("3.Delete a student\n");
                printf("4.List all students\n");
                printf("5.List all the students of CSE Branch\n");
                printf("6.List all the students of CSE residing in Kuvempunagar\n");
                printf("7.To Exit\n");

                printf("\nEnter your choice: ");;
                scanf("%d", &ch);

                switch(ch)
                {
                        case 1: insert_new();
                                    printf("\n");
                                    break;

                        case 2: modify_add();
                                     printf("\n");
                                     break;

                        case 3: delete_st();
                                     printf("\n");
                                     break;

                        case 4: list_all();
                                    printf("\n");
                                    break;

                        case 5: list_cse();
                                    printf("\n");
                                    break;

                        case 6: list_cse_kuv();
                                    printf("\n");
                                    break;

                        case 7: exit(0);
                                    printf("\n");
                                    break;

                        default: printf("Invalid choice!!\n");
                                      printf("\n");
                                      break;
                }
        }

        return 0;
}                                                                                                                                                                                                                                                                                                                                                                   244,4-32      99%
                                                                                                                                                                                                                                                                                                                                                                                                     }
